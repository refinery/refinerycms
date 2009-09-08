class PagePart < ActiveRecord::Base

  belongs_to :page
  
  validates_presence_of :title
  
  has_friendly_id :title, :use_slug => true, :strip_diacritics => true
  
  def content
    self.body
  end
  
  def content=(value)
    self.body = value
  end

end