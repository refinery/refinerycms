require 'globalize3'

class Page < ActiveRecord::Base

  # when a dialog pops up to link to a page, how many pages per page should there be
  PAGES_PER_DIALOG = 14

  # when listing pages out in the admin area, how many pages should show per page
  PAGES_PER_ADMIN_INDEX = 20

  # when collecting the pages path how is each of the pages seperated?
  PATH_SEPARATOR = " - "

  if self.respond_to?(:translates)
    translates :title, :custom_title, :meta_keywords, :meta_description, :browser_title, :include => :seo_meta

    # Set up support for meta tags through translations.
    if defined?(::Page::Translation)
      attr_accessible :title
      # set allowed attributes for mass assignment
      ::Page::Translation.send :attr_accessible, :browser_title, :meta_description,
                                                 :meta_keywords, :locale

      if ::Page::Translation.table_exists?
        # Instruct the Translation model to have meta tags.
        ::Page::Translation.send :is_seo_meta

        fields = ::SeoMeta.attributes.keys.reject{|f|
          self.column_names.map(&:to_sym).include?(f)
        }.map{|a| [a, :"#{a}="]}.flatten
        delegate *(fields << {:to => :translation})
        before_save {|m| m.translation.save}
      end
    end

    before_create :ensure_locale, :if => proc { |c|
      ::Refinery.i18n_enabled?
    }
  end

  attr_accessible :id, :deletable, :link_url, :menu_match, :meta_keywords,
                  :skip_to_first_child, :position, :show_in_menu, :draft,
                  :parts_attributes, :browser_title, :meta_description,
                  :custom_title_type, :parent_id, :custom_title,
                  :created_at, :updated_at, :page_id

  attr_accessor :locale # to hold temporarily
  validates :title, :presence => true

  # Docs for acts_as_nested_set https://github.com/collectiveidea/awesome_nested_set
  acts_as_nested_set :dependent => :destroy # rather than :delete_all

  # Docs for friendly_id http://github.com/norman/friendly_id
  has_friendly_id :title, :use_slug => true,
                  :default_locale => (::Refinery::I18n.default_frontend_locale rescue :en),
                  :reserved_words => %w(index new session login logout users refinery admin images wymiframe),
                  :approximate_ascii => RefinerySetting.find_or_set(:approximate_ascii, false, :scoping => "pages"),
                  :strip_non_ascii => RefinerySetting.find_or_set(:strip_non_ascii, false, :scoping => "pages")

  has_many :parts,
           :class_name => "PagePart",
           :order => "position ASC",
           :inverse_of => :page,
           :dependent => :destroy,
           :include => ((:translations) if defined?(::PagePart::Translation))

  accepts_nested_attributes_for :parts, :allow_destroy => true

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title, :meta_keywords, :meta_description,
                              :custom_title, :browser_title, :all_page_part_content]

  before_destroy :deletable?
  after_save :reposition_parts!, :invalidate_cached_urls, :expire_page_caching
  after_destroy :expire_page_caching

  # Wrap up the logic of finding the pages based on the translations table.
  if defined?(::Page::Translation)
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
  else
    def self.with_globalize(conditions = {})
      where(conditions)
    end
  end

  scope :live, where(:draft => false)
  scope :by_title, proc {|t| with_globalize(:title => t)}

  # Shows all pages with :show_in_menu set to true, but it also
  # rejects any page that has not been translated to the current locale.
  # This works using a query against the translated content first and then
  # using all of the page_ids we further filter against this model's table.
  scope :in_menu, proc { where(:show_in_menu => true).with_globalize }

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

    return false
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
    elsif self.class.use_marketable_urls?
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
    # :id => nil is important to prevent any other params[:id] from interfering with this route.
    url_normal.merge(:path => nested_url, :id => nil)
  end

  def url_normal
    {:controller => '/pages', :action => 'show', :path => nil, :id => to_param}
  end

  def with_locale_param(url_hash)
    if self.class.different_frontend_locale?
      url_hash.update(:locale => ::Refinery::I18n.current_frontend_locale)
    end
    url_hash
  end

  # Returns an array with all ancestors to_param, allow with its own
  # Ex: with an About page and a Mission underneath,
  # Page.find('mission').nested_url would return:
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
      :title => (page_title if respond_to?(:page_title)) || title,
      :type => self.class.name,
      :url => url
    }
  end

  class << self
    # Accessor to find out the default page parts created for each new page
    def default_parts
      RefinerySetting.find_or_set(:default_page_parts, ["Body", "Side Body"])
    end

    # Wraps up all the checks that we need to do to figure out whether
    # the current frontend locale is different to the current one set by ::I18n.locale.
    # This terminates in a false if i18n engine is not defined or enabled.
    def different_frontend_locale?
      ::Refinery.i18n_enabled? && ::Refinery::I18n.current_frontend_locale != ::I18n.locale
    end

    # Returns how many pages per page should there be when paginating pages
    def per_page(dialog = false)
      dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
    end

    def use_marketable_urls?
      RefinerySetting.find_or_set(:use_marketable_urls, true, :scoping => 'pages')
    end

    def expire_page_caching
      begin
        Rails.cache.delete_matched(/.*pages.*/)
      rescue NotImplementedError
        Rails.cache.clear
        warn "**** [REFINERY] The cache store you are using is not compatible with Rails.cache#delete_matched - clearing entire cache instead ***"
      end
    end
  end

  # Accessor method to get a page part from a page.
  # Example:
  #
  #    Page.first.content_for(:body)
  #
  # Will return the body page part of the first page.
  def content_for(part_title)
    part = self.parts.detect do |part|
      part.title.present? and #protecting against the problem that occurs when have nil title
      part.title == part_title.to_s or
      part.title.downcase.gsub(" ", "_") == part_title.to_s.downcase.gsub(" ", "_")
    end

    part.try(:body)
  end

  def [](part_title)
    # Allow for calling attributes with [] shorthand (eg page[:parent_id])
    return super if self.respond_to?(part_title.to_s.to_sym) or self.attributes.has_key?(part_title.to_s)

    Refinery.deprecate({
      :what => "page[#{part_title.inspect}]",
      :when => '1.1',
      :replacement => "page.content_for(#{part_title.inspect})",
      :caller => caller
    })

    content_for(part_title)
  end

  # In the admin area we use a slightly different title to inform the which pages are draft or hidden pages
  def title_with_meta
    title = if self.title.nil?
      [::Page::Translation.where(:page_id => self.id, :locale => Globalize.locale).first.try(:title).to_s]
    else
      [self.title.to_s]
    end

    title << "<em>(#{::I18n.t('hidden', :scope => 'admin.pages.page')})</em>" unless show_in_menu?
    title << "<em>(#{::I18n.t('draft', :scope => 'admin.pages.page')})</em>" if draft?

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
    if self.class.use_marketable_urls? && self.class.friendly_id_config.reserved_words.include?(sluggified)
      sluggified << "-page"
    end
    sluggified
  end

private

  def invalidate_cached_urls
    return true unless self.class.use_marketable_urls?

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
