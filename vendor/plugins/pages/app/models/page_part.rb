class PagePart < ActiveRecord::Base

  belongs_to :page

  validates_presence_of :title
  alias_attribute :content, :body

  # FIXME for Rails 3 (gem not yet compatible) has_friendly_id :title, :use_slug => true

end
