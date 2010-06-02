class PagePart < ActiveRecord::Base

  belongs_to :page

  validates_presence_of :title
  alias_attribute :content, :body

  has_friendly_id :title, :use_slug => true

  def to_param
    "page_part_#{super}"
  end

  before_save :normalise_text_fields

protected
  def normalise_text_fields
    unless self.body.blank? or self.body =~ /^\</
      self.body = "<p>#{self.body.gsub("\r\n\r\n", "</p><p>").gsub("\r\n", "<br/>")}</p>"
    end
  end

end
