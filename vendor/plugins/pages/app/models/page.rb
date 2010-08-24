class Page < ActiveRecord::Base
  validates_presence_of :title

  acts_as_tree :order => "position ASC", :include => [:children, :slugs]

  # Docs for friendly_id http://github.com/norman/friendly_id
  has_friendly_id :title, :use_slug => true,
                  :reserved_words => %w(index new session login logout users refinery admin images wymiframe)

  has_many :parts, :class_name => "PagePart", :order => "position ASC", :inverse_of => :page
  accepts_nested_attributes_for :parts, :allow_destroy => true

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title, :meta_keywords, :meta_description, :custom_title, :browser_title, :all_page_part_content]

  before_destroy :deletable?
  after_save :reposition_parts!
  after_save :invalidate_child_cached_url

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
    self.deletable && self.link_url.blank? and self.menu_match.blank?
  end

  # Repositions the child page_parts that belong to this page.
  # This ensures that they are in the correct 0,1,2,3,4... etc order.
  def reposition_parts!
    self.parts.each_with_index do |part, index|
      part.update_attribute(:position, index)
    end
  end

  # Before destroying a page we check to see if it's a deletable page or not
  # Refinery system pages are not deletable.
  def destroy
    if self.deletable?
      super
    else
      unless RAILS_ENV == "test"
        # give useful feedback when trying to delete from console
        puts "This page is not deletable. Please use .destroy! if you really want it deleted "
        puts "unset .link_url," if self.link_url.present?
        puts "unset .menu_match," if self.menu_match.present?
        puts "set .deletable to true" unless self.deletable
      end

      return false
    end
  end

  # If you want to destroy a page that is set to be not deletable this is the way to do it.
  def destroy!
    self.menu_match = nil
    self.link_url = nil
    self.deletable = true

    self.destroy
  end

  def indented_title
    "#{"--" * self.ancestors.size} #{self.title}".chomp
  end

  # Used for the browser title to get the full path to this page
  # It automatically prints out this page title and all of it's parent page titles joined by a PATH_SEPARATOR
  def path(reverse = true)
    unless self.parent.nil?
      parts = [self.title, self.parent.path(reverse)]
      parts.reverse! if reverse
      parts.join(PATH_SEPARATOR)
    else
      self.title
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
    if self.link_url.present?
      self.link_url =~ /^\// ? {:controller => self.link_url} : self.link_url
    elsif use_marketable_urls?
      url_marketable
    elsif self.to_param.present?
      url_normal
    end
  end

  def url_marketable
    {:controller => "/pages", :action => "show", :path => self.nested_url}
  end

  def url_normal
    {:controller => "/pages", :action => "show", :id => self.to_param}
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
    self.parent ? [parent.nested_url, self.to_param].flatten : [self.to_param]
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
    not self.draft?
  end

  # Return true if this page can be shown in the navigation.
  # If it's a draft or is set to not show in the menu it will return false.
  # If any of the page's ancestors aren't to be shown in the menu then this page is not either.
  def in_menu?
    self.live? && self.show_in_menu? && self.ancestors.all? { |a| a.in_menu? }
  end

  # Returns true if this page is the home page or links to it.
  def home?
    self.link_url == "/"
  end

  # Returns all visible sibling pages that can be rendered for the menu
  def shown_siblings
    self.siblings.reject { |sibling| not sibling.in_menu? }
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
    def top_level(include_children = false)
      include_associations = [:parts]
      include_associations.push(:slugs) if self.class.methods.include? "find_one_with_friendly"
      include_associations.push(:children) if include_children
      find_all_by_parent_id(nil,
                            :conditions => {:show_in_menu => true, :draft => false},
                            :order => "position ASC",
                            :include => include_associations.presence)
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
        part.title == part_title.to_s or
        part.title.downcase.gsub(" ", "_") == part_title.to_s.downcase.gsub(" ", "_")
      end

      return part.body unless part.nil?
    end

    super_value
  end

  # In the admin area we use a slightly different title to inform the which pages are draft or hidden pages
  def title_with_meta
    title = self.title
    title << " <em>(hidden)</em>" unless self.show_in_menu?
    title << " <em>(draft)</em>" if self.draft?

    title.strip
  end

  # Used to index all the content on this page so it can be easily searched.
  def all_page_part_content
    self.parts.collect {|p| p.body}.join(" ")
  end

  ##
  # Protects generated slugs from title if they are in the list of reserved words
  # This applies mostly to plugin-generated pages.
  #
  # Returns the sluggified string
  def normalize_friendly_id(slug_string)
    sluggified = super
    if use_marketable_urls? && self.class.friendly_id_config.reserved_words.include?(sluggified)
      sluggified += "-page"
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
end
