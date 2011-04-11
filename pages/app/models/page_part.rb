class PagePart < ActiveRecord::Base

  attr_accessible :title, :content, :position, :body, :created_at,
                  :updated_at, :page_id
  belongs_to :page

  validates :title, :presence => true
  alias_attribute :content, :body

  translates :body if respond_to?(:translates)

  def to_param
    "page_part_#{title.downcase.gsub(/\W/, '_')}"
  end

  before_save :normalise_text_fields
  if defined?(::PagePart::Translation)
    ::PagePart::Translation.module_eval do
      attr_accessible :locale
    end
  end
protected
  def normalise_text_fields
    unless body.blank? or body =~ /^\</
      self.body = "<p>#{body.gsub("\r\n\r\n", "</p><p>").gsub("\r\n", "<br/>")}</p>"
    end
  end

end
