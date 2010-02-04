class Page < ActiveRecord::Base

  validates_presence_of :title

  acts_as_tree :order => "position ASC", :include => [:children, :slugs]
	
	# Docs for friendly_id http://github.com/norman/friendly_id
  has_friendly_id :title, :use_slug => true, :strip_diacritics => true

  has_many :parts, :class_name => "PagePart", :order => "position ASC"
  accepts_nested_attributes_for :parts, :allow_destroy => true
	
	# Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:title, :meta_keywords, :meta_description, :custom_title, :browser_title, :all_page_part_content],
          			  :index_file => %W(#{RAILS_ROOT} tmp index)

  before_destroy :deletable?

	# when a dialog pops up to link to a page, how many pages per page should there be
	PAGES_PER_DIALOG = 14
	
	# when listing pages out in the admin area, how many pages should show per page
	PAGES_PER_ADMIN_INDEX = 20
	
	# when collecting the pages path how is each of the pages seperated?
	PATH_SEPERATOR = " - "

  # Am I allowed to delete this page?
  # If a link_url is set we don't want to break the link so we don't allow them to delete
  # If deletable is set to false then we don't allow this page to be deleted. These are often Refinery system pages
  def deletable?
    self.deletable && self.link_url.blank? and self.menu_match.blank?
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
    self.update_attributes({
      :menu_match => nil,
      :link_url => nil,
      :deletable => true
    })
    self.destroy
  end

  # Used for the browser title to get the full path to this page
  # It automatically prints out this page title and all of it's parent page titles joined by a PATH_SEPERATOR
  def path(reverse = true)
    unless self.parent.nil?
      parts = [self.title, self.parent.path(reverse)]
      parts.reverse! if reverse
      parts.join(PATH_SEPERATOR)
    else
      self.title
    end
  end
	
	# When this page is rendered in the navigation, where should it link?
	# If a custom "link_url" is set, it uses that otherwise it defaults to a normal page URL.
	# The "link_url" is often used to link to a plugin rather than a page.
	# 
	# For example if I had a "Contact Us" page I don't want it to just render a contact us page
	# I want it to show the Inquiries form so I can collect inquiries. So I would set the "link_url"
	# to "/inquiries/new"
  def url
    if self.link_url.present?
      self.link_url
    elsif self.to_param.present?
      "/pages/#{self.to_param}"
    end
  end
	
	# Returns true if this page is "published"
  def live?
    not self.draft?
  end
	
	# Return true if this page can be shown in the navigation. If it's a draft or is set to not show in the menu it will return false.
  def in_menu?
    is_in_menu = self.live? && self.show_in_menu?
    self.ancestors.each {|a| is_in_menu = false unless a.in_menu? }
    is_in_menu
  end
	
	# Returns true if this page is the home page or links to it.
  def home?
    self.link_url == "/"
  end
	
	# Returns all visible sibling pages that can be rendered for the menu
  def shown_siblings
    self.siblings.reject { |sibling| not sibling.in_menu? }
  end
	
	# Returns all the top level pages, usually to render the top level navigation.
  def self.top_level(include_children = false)
    include_associations = [:parts]
    include_associations.push(:slugs) if self.class.methods.include? "find_one_with_friendly"
    include_associations.push(:children) if include_children
    find_all_by_parent_id(nil,:conditions => {:show_in_menu => true, :draft => false}, :order => "position ASC", :include => include_associations)
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
      part = self.parts.detect {|part| (part.title == part_title.to_s) || (part.title.downcase.gsub(" ", "_") == part_title.to_s.downcase.gsub(" ", "_")) }

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
	
	# Returns how many pages per page should there be when paginating pages
  def self.per_page(dialog = false)
    dialog ? PAGES_PER_DIALOG : PAGES_PER_ADMIN_INDEX
  end

end
