module Refinery
  class Page < ActiveRecord::Base
    # when collecting the pages path how is each of the pages seperated?
    PATH_SEPARATOR = " - "

    if self.respond_to?(:translates)
      translates :title, :menu_title, :meta_keywords, :meta_description, :browser_title, :custom_slug, :include => :seo_meta
    end

    attr_accessible :title

    # Delegate SEO Attributes to globalize3 translation
    seo_fields = ::SeoMeta.attributes.keys.map{|a| [a, :"#{a}="]}.flatten
    delegate *(seo_fields << {:to => :translation})

    after_save proc {|m| m.translation.save}

    # Wrap up the logic of finding the pages based on the translations table.
    def self.with_globalize(conditions = {})
      conditions = {:locale => Globalize.locale}.merge(conditions)
      globalized_conditions = {}
      conditions.keys.each do |key|
        if (translated_attribute_names.map(&:to_s) | %w(locale)).include?(key.to_s)
          globalized_conditions["#{self.translation_class.table_name}.#{key}"] = conditions.delete(key)
        end
      end
      # A join implies readonly which we don't really want.
      joins(:translations).where(globalized_conditions).where(conditions).readonly(false)
    end

    before_create :ensure_locale, :if => proc { |c| ::Refinery.i18n_enabled? }

    attr_accessible :id, :deletable, :link_url, :menu_match, :meta_keywords,
                    :skip_to_first_child, :position, :show_in_menu, :draft,
                    :parts_attributes, :browser_title, :meta_description,
                    :parent_id, :menu_title, :created_at, :updated_at,
                    :page_id, :layout_template, :view_template, :custom_slug

    attr_accessor :locale # to hold temporarily
    validates :title, :presence => true

    # Docs for acts_as_nested_set https://github.com/collectiveidea/awesome_nested_set
    # rather than :delete_all we want :destroy
    unless $rake_assets_precompiling
      acts_as_nested_set :dependent => :destroy

      # Docs for friendly_id http://github.com/norman/friendly_id
      has_friendly_id :custom_slug_or_title, :use_slug => true,
                      :default_locale => (::Refinery::I18n.default_frontend_locale rescue :en),
                      :reserved_words => %w(index new session login logout users refinery admin images wymiframe),
                      :approximate_ascii => ::Refinery::Setting.find_or_set(:approximate_ascii, false, :scoping => "pages"),
                      :strip_non_ascii => ::Refinery::Setting.find_or_set(:strip_non_ascii, false, :scoping => "pages")
    end

    def custom_slug_or_title
      if custom_slug.present?
        custom_slug
      elsif menu_title.present?
        menu_title
      else
        title
      end
    end

    has_many :parts,
             :foreign_key => :refinery_page_id,
             :class_name => '::Refinery::PagePart',
             :order => 'position ASC',
             :inverse_of => :page,
             :dependent => :destroy,
             :include => ((:translations) if ::Refinery::PagePart.respond_to?(:translation_class))

    accepts_nested_attributes_for :parts, :allow_destroy => true

    # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
    acts_as_indexed :fields => [:title, :meta_keywords, :meta_description,
                                :menu_title, :browser_title, :all_page_part_content]

    before_destroy :deletable?
    after_save :reposition_parts!, :invalidate_cached_urls, :expire_page_caching
    after_update :invalidate_cached_urls
    after_destroy :expire_page_caching

    scope :live, where(:draft => false)
    scope :by_title, proc {|t| with_globalize(:title => t)}

    # Shows all pages with :show_in_menu set to true, but it also
    # rejects any page that has not been translated to the current locale.
    # This works using a query against the translated content first and then
    # using all of the page_ids we further filter against this model's table.
    scope :in_menu, proc { where(:show_in_menu => true).with_globalize }

    scope :fast_menu, proc {
      # First, apply a filter to determine which pages to show.
      # We need to join to the page's slug to avoid multiple queries.
      pages = live.in_menu.includes(:slug, :slugs).order('lft ASC')

      # Now we only want to select particular columns to avoid any further queries.
      # Title and menu_title are retrieved in the next block below so they are not here.
      menu_columns.each do |column|
        pages = pages.select(arel_table[column.to_sym])
      end

      # We have to get title and menu_title from the translations table.
      # To avoid calling globalize3 an extra time, we get title as page_title
      # and we get menu_title as page_menu_title.
      # These is used in 'to_refinery_menu_item' in the Page model.
      %w(title menu_title).each do |column|
        pages = pages.joins(:translations).select(
          "#{translation_class.table_name}.#{column} as page_#{column}"
        )
      end

      pages
    }

    # Am I allowed to delete this page?
    # If a link_url is set we don't want to break the link so we don't allow them to delete
    # If deletable is set to false then we don't allow this page to be deleted. These are often Refinery system pages
    def deletable?
      deletable && link_url.blank? and menu_match.blank?
    end

    # Repositions the child page_parts that belong to this page.
    # This ensures that they are in the correct 0,1,2,3,4... etc order.
    def reposition_parts!
      parts.each_with_index do |part, index|
        part.update_attribute(:position, index)
      end
    end

    # Before destroying a page we check to see if it's a deletable page or not
    # Refinery system pages are not deletable.
    def destroy
      return super if deletable?

      unless Rails.env.test?
        # give useful feedback when trying to delete from console
        puts "This page is not deletable. Please use .destroy! if you really want it deleted "
        puts "unset .link_url," if link_url.present?
        puts "unset .menu_match," if menu_match.present?
        puts "set .deletable to true" unless deletable
      end

      false
    end

    # If you want to destroy a page that is set to be not deletable this is the way to do it.
    def destroy!
      self.menu_match = nil
      self.link_url = nil
      self.deletable = true

      destroy
    end

    # Used for the browser title to get the full path to this page
    # It automatically prints out this page title and all of it's parent page titles joined by a PATH_SEPARATOR
    def path(options = {})
      # Override default options with any supplied.
      options = {:reversed => true}.merge(options)

      unless parent_id.nil?
        parts = [title, parent.path(options)]
        parts.reverse! if options[:reversed]
        parts.join(PATH_SEPARATOR)
      else
        title
      end
    end

    # When this page is rendered in the navigation, where should it link?
    # If a custom "link_url" is set, it uses that otherwise it defaults to a normal page URL.
    # The "link_url" is often used to link to a plugin rather than a page.
    #
    # For example if I had a "Contact" page I don't want it to just render a contact us page
    # I want it to show the Inquiries form so I can collect inquiries. So I would set the "link_url"
    # to "/contact"
    def url
      if link_url.present?
        link_url_localised?
      elsif ::Refinery::Pages.use_marketable_urls?
        with_locale_param url_marketable
      elsif to_param.present?
        with_locale_param url_normal
      end
    end

    def link_url_localised?
      return link_url unless ::Refinery.i18n_enabled?

      current_url = link_url

      if current_url =~ %r{^/} && ::Refinery::I18n.current_frontend_locale != ::Refinery::I18n.default_frontend_locale
        current_url = "/#{::Refinery::I18n.current_frontend_locale}#{current_url}"
      end

      current_url
    end

    def url_marketable
      # except(:id) is important to prevent any other params[:id] from interfering with this route.
      url_normal.merge(:path => nested_url).except(:id)
    end

    def url_normal
      {:controller => '/refinery/pages', :action => 'show', :path => nil, :id => to_param}
    end

    def with_locale_param(url_hash)
      if self.class.different_frontend_locale?
        url_hash.update(:locale => ::Refinery::I18n.current_frontend_locale)
      end
      url_hash
    end

    # Returns an array with all ancestors to_param, allow with its own
    # Ex: with an About page and a Mission underneath,
    # ::Refinery::Page.find('mission').nested_url would return:
    #
    #   ['about', 'mission']
    #
    def nested_url
      Rails.cache.fetch(url_cache_key) { uncached_nested_url }
    end

    def uncached_nested_url
      [parent.try(:nested_url), to_param].compact.flatten
    end

    # Returns the string version of nested_url, i.e., the path that should be generated
    # by the router
    def nested_path
      Rails.cache.fetch(path_cache_key) { ['', nested_url].join('/') }
    end

    def path_cache_key
      [cache_key, 'nested_path'].join('#')
    end

    def url_cache_key
      [cache_key, 'nested_url'].join('#')
    end

    def cache_key
      [Refinery.base_cache_key, ::I18n.locale, to_param].compact.join('/')
    end

    # Returns true if this page is "published"
    def live?
      not draft?
    end

    # Return true if this page can be shown in the navigation.
    # If it's a draft or is set to not show in the menu it will return false.
    def in_menu?
      live? && show_in_menu?
    end

    def not_in_menu?
      not in_menu?
    end

    # Returns true if this page is the home page or links to it.
    def home?
      link_url == '/'
    end

    # Returns all visible sibling pages that can be rendered for the menu
    def shown_siblings
      siblings.reject(&:not_in_menu?)
    end

    def to_refinery_menu_item
      {
        :id => id,
        :lft => lft,
        :menu_match => menu_match,
        :parent_id => parent_id,
        :rgt => rgt,
        :title => page_menu_title.blank? ? page_title : page_menu_title,
        :type => self.class.name,
        :url => url
      }
    end

    class << self
      # Accessor to find out the default page parts created for each new page
      def default_parts
        ::Refinery::Setting.find_or_set(:default_page_parts, ["Body", "Side Body"])
      end

      # Wraps up all the checks that we need to do to figure out whether
      # the current frontend locale is different to the current one set by ::I18n.locale.
      # This terminates in a false if i18n engine is not defined or enabled.
      def different_frontend_locale?
        ::Refinery.i18n_enabled? && ::Refinery::I18n.current_frontend_locale != ::I18n.locale
      end

      # Override this method to change which columns you want to select to render your menu.
      # title and menu_title are always retrieved so omit these.
      def menu_columns
        %w(id depth parent_id lft rgt link_url menu_match)
      end

      # Returns how many pages per page should there be when paginating pages
      def per_page(dialog = false)
        dialog ? Pages.pages_per_dialog : Pages.pages_per_admin_index
      end

      def expire_page_caching
        begin
          Rails.cache.delete_matched(/.*pages.*/)
        rescue NotImplementedError
          Rails.cache.clear
          warn "**** [REFINERY] The cache store you are using is not compatible with Rails.cache#delete_matched - clearing entire cache instead ***"
        ensure
          return true # so that other callbacks process.
        end
      end
    end

    # Accessor method to get a page part from a page.
    # Example:
    #
    #    ::Refinery::Page.first.content_for(:body)
    #
    # Will return the body page part of the first page.
    def content_for(part_title)
      # self.parts is usually already eager loaded so we can now just grab
      # the first element matching the title we specified.
      part = self.parts.detect do |part|
        part.title.present? and # protecting against the problem that occurs when have nil title
        part.title == part_title.to_s or
        part.title.downcase.gsub(" ", "_") == part_title.to_s.downcase.gsub(" ", "_")
      end

      part.try(:body)
    end

    # In the admin area we use a slightly different title to inform the which pages are draft or hidden pages
    # We show the title from the next available locale if there is no title for the current locale
    def title_with_meta
      if self.title.present?
        title = [self.title]
      else
        title = [self.translations.detect {|t| t.title.present?}.title]
      end

      title << "<em>(#{::I18n.t('hidden', :scope => 'refinery.admin.pages.page')})</em>" unless show_in_menu?
      title << "<em>(#{::I18n.t('draft', :scope => 'refinery.admin.pages.page')})</em>" if draft?

      title.join(' ')
    end

    # Used to index all the content on this page so it can be easily searched.
    def all_page_part_content
      parts.collect {|p| p.body}.join(" ")
    end

    ##
    # Protects generated slugs from title if they are in the list of reserved words
    # This applies mostly to plugin-generated pages.
    #
    # Returns the sluggified string
    def normalize_friendly_id(slug_string)
      slug_string.gsub!('_', '-')
      sluggified = super
      if ::Refinery::Pages.use_marketable_urls? && self.class.friendly_id_config.reserved_words.include?(sluggified)
        sluggified << "-page"
      end
      sluggified
    end

  private

    def invalidate_cached_urls
      return true unless ::Refinery::Pages.use_marketable_urls?

      [self, children].flatten.each do |page|
        Rails.cache.delete(page.url_cache_key)
        Rails.cache.delete(page.path_cache_key)
      end
    end
    alias_method :invalidate_child_cached_url, :invalidate_cached_urls

    def ensure_locale
      unless self.translations.present?
        self.translations.build :locale => ::Refinery::I18n.default_frontend_locale
      end
    end

    def expire_page_caching
      self.class.expire_page_caching
    end
  end
end
