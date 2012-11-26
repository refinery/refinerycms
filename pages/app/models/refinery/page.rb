# Encoding: utf-8
require 'acts_as_indexed'
require 'friendly_id'
require 'refinery/core/base_model'

module Refinery
  class Page < Core::BaseModel
    extend FriendlyId

    # when collecting the pages path how is each of the pages seperated?
    PATH_SEPARATOR = " - "

    translates :title, :menu_title, :custom_slug, :slug, :include => :seo_meta

    class Translation
      is_seo_meta
      attr_accessible :browser_title, :meta_description, :meta_keywords, :locale
    end

    attr_accessible :title

    # Delegate SEO Attributes to globalize3 translation
    seo_fields = ::SeoMeta.attributes.keys.map{|a| [a, :"#{a}="]}.flatten
    delegate(*(seo_fields << {:to => :translation}))

    attr_accessible :id, :deletable, :link_url, :menu_match, :meta_keywords,
                    :skip_to_first_child, :position, :show_in_menu, :draft,
                    :parts_attributes, :browser_title, :meta_description,
                    :parent_id, :menu_title, :page_id, :layout_template,
                    :view_template, :custom_slug, :slug

    attr_accessor :locale # to hold temporarily
    validates :title, :presence => true

    validates :custom_slug, :uniqueness => true, :allow_blank => true

    # Docs for acts_as_nested_set https://github.com/collectiveidea/awesome_nested_set
    # rather than :delete_all we want :destroy
    acts_as_nested_set :dependent => :destroy

    # Docs for friendly_id http://github.com/norman/friendly_id
    friendly_id :custom_slug_or_title, :use => [:reserved, :globalize, :scoped],
                :reserved_words => %w(index new session login logout users refinery admin images wymiframe),
                :scope => :parent

    # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
    acts_as_indexed :fields => [:title, :meta_keywords, :meta_description,
                                :menu_title, :browser_title, :all_page_part_content]

    has_many :parts,
             :foreign_key => :refinery_page_id,
             :class_name => '::Refinery::PagePart',
             :order => 'position ASC',
             :inverse_of => :page,
             :dependent => :destroy,
             :include => ((:translations) if ::Refinery::PagePart.respond_to?(:translation_class))

    accepts_nested_attributes_for :parts, :allow_destroy => true

    before_save { |m| m.translation.save }
    before_create :ensure_locale
    before_destroy :deletable?
    after_save :reposition_parts!, :expire_page_caching
    after_destroy :expire_page_caching

    class << self
      # Live pages are 'allowed' to be shown in the frontend of your website.
      # By default, this is all pages that are not set as 'draft'.
      def live
        where(:draft => false)
      end

      # With slugs scoped to the parent page we need to find a page by its full path.
      # For example with about/example we would need to find 'about' and then its child
      # called 'example' otherwise it may clash with another page called /example.
      def find_by_path(path)
        split_path = path.to_s.split('/').reject(&:blank?)
        page = ::Refinery::Page.by_slug(split_path.shift, :parent_id => nil).first
        page = page.children.by_slug(split_path.shift).first until page.nil? || split_path.empty?

        page
      end

      # Helps to resolve the situation where you have a path and an id
      # and if the path is unfriendly then a different finder method is required
      # than find_by_path.
      def find_by_path_or_id(path, id)
        if Refinery::Pages.marketable_urls && path.present?
          if path.friendly_id?
            find_by_path(path)
          else
            find(path)
          end
        elsif id.present?
          find(id)
        end
      end

      # Finds pages by their title.  This method is necessary because pages
      # are translated which means the title attribute does not exist on the
      # pages table thus requiring us to find the attribute on the translations table
      # and then join to the pages table again to return the associated record.
      def by_title(title)
        with_globalize(:title => title)
      end

      # Finds pages by their slug.  See by_title
      def by_slug(slug, conditions={})
        with_globalize({ :locale => Refinery::I18n.frontend_locales.map(&:to_s),
                         :slug => slug }.merge(conditions))
      end

      # Shows all pages with :show_in_menu set to true, but it also
      # rejects any page that has not been translated to the current locale.
      # This works using a query against the translated content first and then
      # using all of the page_ids we further filter against this model's table.
      def in_menu
        where(:show_in_menu => true).with_globalize
      end

      def fast_menu
        live.in_menu.order('lft ASC').includes(:translations)
      end

      # Wrap up the logic of finding the pages based on the translations table.
      def with_globalize(conditions = {})
        conditions = {:locale => ::Globalize.locale.to_s}.merge(conditions)
        globalized_conditions = {}
        conditions.keys.each do |key|
          if (translated_attribute_names.map(&:to_s) | %w(locale)).include?(key.to_s)
            globalized_conditions["#{self.translation_class.table_name}.#{key}"] = conditions.delete(key)
          end
        end
        # A join implies readonly which we don't really want.
        joins(:translations).where(globalized_conditions).where(conditions).readonly(false)
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

    # The canonical page for this particular page.
    # Consists of:
    #   * The default locale's translated slug
    def canonical
      Globalize.with_locale(::Refinery::I18n.default_frontend_locale){ url }
    end

    # The canonical slug for this particular page.
    # This is the slug for the default frontend locale.
    def canonical_slug
      Globalize.with_locale(::Refinery::I18n.default_frontend_locale) { slug }
    end

    # Returns in cascading order: custom_slug or menu_title or title depending on
    # which attribute is first found to be present for this page.
    def custom_slug_or_title
      custom_slug.presence || menu_title.presence || title
    end

    # Am I allowed to delete this page?
    # If a link_url is set we don't want to break the link so we don't allow them to delete
    # If deletable is set to false then we don't allow this page to be deleted. These are often Refinery system pages
    def deletable?
      deletable && link_url.blank? and menu_match.blank?
    end

    # Repositions the child page_parts that belong to this page.
    # This ensures that they are in the correct 0,1,2,3,4... etc order.
    def reposition_parts!
      reload.parts.each_with_index do |part, index|
        part.update_attributes :position => index
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

    def url
      Refinery::Pages::Url.build(self)
    end

    def link_url_localised?
      Refinery.deprecate "Refinery::Page#link_url_localised?", :when => '2.2', :replacement => "Refinery::Pages::Url::Localised#url"
      Refinery::Pages::Url::Localised.new(self).url
    end

    def url_normal
      Refinery.deprecate "Refinery::Page#url_normal", :when => '2.2', :replacement => "Refinery::Pages::Url::Normal#url"
      Refinery::Pages::Url::Normal.new(self).url
    end

    def url_marketable
      Refinery.deprecate "Refinery::Page#url_marketable", :when => '2.2', :replacement => "Refinery::Pages::Url::Marketable#url"
      Refinery::Pages::Url::Marketable.new(self).url
    end

    def uncached_nested_url
      [parent.try(:uncached_nested_url), to_param.to_s].compact.flatten
    end

    # Returns an array with all ancestors to_param, allow with its own
    # Ex: with an About page and a Mission underneath,
    # ::Refinery::Page.find('mission').nested_url would return:
    #
    #   ['about', 'mission']
    #
    alias_method :nested_url, :uncached_nested_url

    # Returns the string version of nested_url, i.e., the path that should be generated
    # by the router
    def nested_path
      ['', nested_url].join('/')
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

    def refinery_menu_title
      [menu_title, title].detect(&:present?)
    end

    def to_refinery_menu_item
      {
        :id => id,
        :lft => lft,
        :menu_match => menu_match,
        :parent_id => parent_id,
        :rgt => rgt,
        :title => refinery_menu_title,
        :type => self.class.name,
        :url => url
      }
    end

    # Accessor method to test whether a page part
    # exists and has content for this page.
    # Example:
    #
    #   ::Refinery::Page.first.content_for?(:body)
    #
    # Will return true if the page has a body page part and it is not blank.
    def content_for?(part_title)
      content_for(part_title).present?
    end

    # Accessor method to get a page part from a page.
    # Example:
    #
    #    ::Refinery::Page.first.content_for(:body)
    #
    # Will return the body page part of the first page.
    def content_for(part_title)
      part_with_title(part_title).try(:body)
    end

    # Accessor method to get a page part object from a page.
    # Example:
    #
    #    ::Refinery::Page.first.part_with_title(:body)
    #
    # Will return the Refinery::PagePart object with that title using the first page.
    def part_with_title(part_title)
      # self.parts is usually already eager loaded so we can now just grab
      # the first element matching the title we specified.
      self.parts.detect do |part|
        part.title.present? and # protecting against the problem that occurs when have nil title
        part.title == part_title.to_s or
        part.title.downcase.gsub(" ", "_") == part_title.to_s.downcase.gsub(" ", "_")
      end
    end

    # Used to index all the content on this page so it can be easily searched.
    def all_page_part_content
      parts.map(&:body).join(" ")
    end

    ##
    # Protects generated slugs from title if they are in the list of reserved words
    # This applies mostly to plugin-generated pages.
    # This only kicks in when Refinery::Pages.marketable_urls is enabled.
    #
    # Returns the sluggified string
    def normalize_friendly_id_with_marketable_urls(slug_string)
      sluggified = slug_string.to_slug.normalize!
      if Refinery::Pages.marketable_urls && self.class.friendly_id_config.reserved_words.include?(sluggified)
        sluggified << "-page"
      end
      sluggified
    end
    alias_method_chain :normalize_friendly_id, :marketable_urls

  private

    # Make sures that a translation exists for this page.
    # The translation is set to the default frontend locale.
    def ensure_locale
      if self.translations.empty?
        self.translations.build(:locale => Refinery::I18n.default_frontend_locale)
      end
    end

    def expire_page_caching
      self.class.expire_page_caching
    end
  end
end
