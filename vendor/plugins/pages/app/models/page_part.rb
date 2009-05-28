class PagePart < ActiveRecord::Base

  belongs_to :page
  
  validates_presence_of :title
  
  has_friendly_id :title
  
end