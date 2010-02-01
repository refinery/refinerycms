class PagePart < ActiveRecord::Base

  belongs_to :page

  validates_presence_of :title
  alias_attribute :content, :body

  has_friendly_id :title, :use_slug => true, :strip_diacritics => true

end