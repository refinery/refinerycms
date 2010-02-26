class PagePart < ActiveRecord::Base

  belongs_to :page

  validates_presence_of :title
  alias_attribute :content, :body

  def to_param
    "page_part_#{self.title.downcase.gsub(" ", "_")}"
  end

end
