class Page < ActiveRecord::Base
  
  validates_presence_of :title
  
  acts_as_tree :order => "position"
  
  has_friendly_id :title
  
  belongs_to :image
  
  has_many :parts, :class_name => "PagePart"
  accepts_nested_attributes_for :parts, :allow_destroy => true
    
  before_destroy :deletable?
  
  # used for the browser title to get the full path to this page
  def path(reverse = true)
    unless self.parent.nil?
      if reverse
        "#{self.title} - #{self.parent.path}"        
      else
        "#{self.parent.path(false)} - #{self.title}"
      end
    else
      self.title
    end
  end

  def url
    if not (self.link_url.blank?)
      self.link_url
    elsif not self.to_param.blank?
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
	
	def self.top_level
		find_all_by_parent_id(nil, :order => "position ASC")
	end
	
	def [](part_title)
	  if (super_value = super).blank?
	    part = self.parts.find_by_title(part_title.to_s)
	    unless part.nil?
	      return part.body
      end
    end
    super_value
	end
	
end