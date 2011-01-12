require 'globalize3'

class Page < ActiveRecord::Base

  translates :title, :meta_keywords, :meta_description, :browser_title if self.respond_to?(:translates)
  attr_accessor :locale # to hold temporarily
  validates :title, :presence => true

  acts_as_nested_set

  # Docs for friendly_id http://github.com/norman/friendly_id
  has_friendly_id :title, :use_slug => true,
                  :default_locale => (defined?(::Refinery::I18n.default_frontend_locale) ? ::Refinery::I18n.default_frontend_locale : :en),
                  :reserved_words => %w(index new session login logout users refinery admin images wymiframe),
                  :approximate_ascii => RefinerySetting.find_or_set(:approximate_ascii, false, :scoping => "pages")

  has_many :parts,
           :class_name => "PagePart",
           :order => "position ASC",
           :inverse_of => :page,
           :dependent => :destroy

  accepts_nested_attributes_for :parts, :allow_destroy => true

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title, :meta_keywords, :meta_description,
                              :custom_title, :browser_title, :all_page_part_content]

  before_destroy :deletable?
  after_save :reposition_parts!
  after_save :invalidate_child_cached_url

  scope :live, where(:draft => false)

  # shows all pages with :show_in_menu set to true, but it also
  # rejects any page that has not been translated to the current locale.
  scope :in_menu, lambda {
    pages = Arel::Table.new(Page.table_name)
    translations = Arel::Table.new(Page.translations_table_name)

    includes(:translations).where(:show_in_menu => true).where(
      translations[:locale].eq(Globalize.locale)).where(pages[:id].eq(translations[:page_id]))
  }

  # when a dialog pops up to link to a page, how many pages per page should there be
  PAGES_PER_DIALOG = 14

  # when listing pages out in the admin area, how many pages should show per page
  PAGES_PER_ADMIN_INDEX = 20

  # when collecting the pages path how is each of the pages seperated?
  PATH_SEPARATOR = " - "

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
    if deletable?
      super
    else
      unless Rails.env.test?
        # give useful feedback when trying to delete from console
        puts "This page is not deletable. Please use .destroy! if you really want it deleted "
        puts "unset .link_url," if link_url.present?
        puts "unset .menu_match," if menu_match.present?
        puts "set .deletable to true" unless deletable
      end

      return false
    end
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
    # Handle deprecated boolean
    if [true, false].include?(options)
      warning = "Page::path does not want a boolean (you gave #{options.inspect}) anymore. "
      warning << "Please change this to {:reversed => #{options.inspect}}. "
      warn(warning << "\nCalled from #{caller.first.inspect}")
      options = {:reversed => options}
    end

    # Override default options with any supplied.
    options = {:reversed => true}.merge(options)

    unless parent.nil?
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
    elsif use_marketable_urls?
      url_marketable
    elsif to_param.present?
      url_normal
    end
  end

  def link_url_localised?
    if link_url =~ %r{^/} and defined?(::Refinery::I18n) and ::Refinery::I18n.enabled? and
       ::I18n.locale != ::Refinery::I18n.default_frontend_locale
      "/#{::I18n.locale}#{link_url}"
    else
      link_url
    end
  end

  def url_marketable
    # :id => nil is important to prevent any other params[:id] from interfering with this route.
    {:controller => "/pages", :action => "show", :path => nested_url, :id => nil}
  end

  def url_normal
    {:controller => "/pages", :action => "show", :id => to_param}
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
    @nested_path ||= "/#{nested_url.join('/')}"
  end

  def url_cache_key
    "#{cache_key}#nested_url"
  end

  def cache_key
    "#{Refinery.base_cache_key}/#{super}"
  end

  def use_marketable_urls?
    RefinerySetting.find_or_set(:use_marketable_urls, true, :scoping => 'pages')
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

  # Returns true if this page is the home page or links to it.
  def home?
    link_url == "/"
  end

  # Returns all visible sibling pages that can be rendered for the menu
  def shown_siblings
    siblings.reject { |sibling| not sibling.in_menu? }
  end

  class << self
    # Accessor to find out the default page parts created for each new page
    def default_parts
      RefinerySetting.find_or_set(:default_page_parts, ["Body", "Side Body"])
    end

    # Returns how many pages per page should there be when paginating pages
    def per_page(dialog = false)
      dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
    end

    # Returns all the top level pages, usually to render the top level navigation.
    def top_level
      warn("Please use .live.in_menu instead of .top_level")
      roots.where(:show_in_menu => true, :draft => false)
    end
  end

  # Accessor method to get a page part from a page.
  # Example:
  #
  #    Page.first[:body]
  #
  # Will return the body page part of the first page.
  def [](part_title)
    # don't want to override a super method when trying to call a page part.
    # the way that we call page parts seems flawed, will probably revert to page.parts[:title] in a future release.
    if (super_value = super).blank?
      # self.parts is already eager loaded so we can now just grab the first element matching the title we specified.
      part = self.parts.detect do |part|
        part.title.present? and #protecting against the problem that occurs when have nil title
        part.title == part_title.to_s or
        part.title.downcase.gsub(" ", "_") == part_title.to_s.downcase.gsub(" ", "_")
      end

      return part.body unless part.nil?
    end

    super_value
  end

  # In the admin area we use a slightly different title to inform the which pages are draft or hidden pages
  def title_with_meta
    title = self.title.to_s
    title << " <em>(#{::I18n.t('hidden', :scope => 'admin.pages.page')})</em>" unless show_in_menu?
    title << " <em>(#{::I18n.t('draft', :scope => 'admin.pages.page')})</em>" if draft?

    title.strip
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
    sluggified = super
    if use_marketable_urls? && self.class.friendly_id_config.reserved_words.include?(sluggified)
      sluggified << "-page"
    end
    sluggified
  end

  private

  def invalidate_child_cached_url
    return true unless use_marketable_urls?
    children.each do |child|
      Rails.cache.delete(child.url_cache_key)
    end
  end

  def warn(msg)
    warning = ["\n*** DEPRECATION WARNING ***"]
    warning << "#{msg}"
    warning << ""
    $stdout.puts warning.join("\n")
  end
end
