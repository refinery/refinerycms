class Page < ActiveRecord::Base

  validates_presence_of :title

  acts_as_tree :order => "position ASC", :include => [:children, :slugs]

  has_friendly_id :title, :use_slug => true, :strip_diacritics => true

  belongs_to :image
  belongs_to :custom_title_image, :class_name => "Image"

  has_many :parts, :class_name => "PagePart", :order => "position ASC"
  accepts_nested_attributes_for :parts, :allow_destroy => true

  acts_as_indexed :fields => [:title, :meta_keywords, :meta_description, :custom_title, :browser_title, :all_page_part_content],
          :index_file => %W(#{RAILS_ROOT} tmp index)

  before_destroy :deletable?

  # deletable needs to check a couple other fields too
  def deletable?
    self.deletable && self.link_url.blank? and self.menu_match.blank?
  end

  # provide helpful feedback
  def destroy
    if self.deletable?
      super
    else
      puts "This page is not deletable. Please use .destroy! if you really want it gone or first:"
      puts "unset .link_url" if self.link_url.present?
      puts "unset .menu_match" if self.menu_match.present?
      puts "set .deletable to true" unless self.deletable
      return false
    end
  end

  # provide a method to definitely get rid of the page.
  def destroy!
    self.update_attributes({
      :menu_match => nil,
      :link_url => nil,
      :deletable => true
    })
    self.destroy
  end

  # used for the browser title to get the full path to this page
  def path(reverse = true)
    unless self.parent.nil?
      parts = [self.title, self.parent.path(reverse)]
      parts.reverse! if reverse
      parts.join(" - ")
    else
      self.title
    end
  end

  def url
    if self.link_url.present?
      self.link_url
    elsif self.to_param.present?
      "/pages/#{self.to_param}"
    end
  end

  def live?
    not self.draft?
  end

  def in_menu?
    self.live? and self.show_in_menu?
  end

  def home?
    self.link_url == "/"
  end

  def shown_siblings
    self.siblings.reject { |sibling| not sibling.in_menu? }
  end

  def self.top_level(include_children = false)
    include_associations = [:parts]
    include_associations.push(:slugs) if self.class.methods.include? "find_one_with_friendly"
    include_associations.push(:children) if include_children
    find_all_by_parent_id(nil,:conditions => {:show_in_menu => true, :draft => false}, :order => "position ASC", :include => include_associations)
  end

  def [](part_title)
    # don't want to override a super method when trying to call a page part.
    # the way that we call page parts seems flawed, will probably revert to page.parts[:title] in a future release.
    if (super_value = super).blank?
      # self.parts is already eager loaded so we can now just grab the first element matching the title we specified.
      part = self.parts.reject {|part| part.title != part_title.to_s}.first

      return part.body unless part.nil?
    end

    super_value
  end

  def title_with_meta
    "#{self.title} #{"<em>(hidden)</em>" unless self.show_in_menu?} #{"<em>(draft)</em>" if self.draft?}"
  end

  # used for search only
  def all_page_part_content
    self.parts.collect {|p| p.body}.join(" ")
  end

  def self.per_page(dialog = false)
    size = (dialog ? 14 : 20)
  end

end
