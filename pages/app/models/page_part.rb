class PagePart < ActiveRecord::Base

  belongs_to :page

  validates :title, :presence => true
  alias_attribute :content, :body

  translates :body if respond_to?(:translates)

  def to_param
    "page_part_#{title.downcase.gsub(/\W/, '_')}"
  end

  before_save :normalise_text_fields

protected
  def normalise_text_fields
    unless body.blank? or body =~ /^\</
      self.body = "<p>#{body.gsub("\r\n\r\n", "</p><p>").gsub("\r\n", "<br/>")}</p>"
    end
  end

end
