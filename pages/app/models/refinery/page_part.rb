module Refinery
  class PagePart < Refinery::Core::Base

    attr_accessible :title, :content, :position, :body, :created_at,
                    :updated_at, :refinery_page_id
    belongs_to :page, :class_name => '::Refinery::Page', :foreign_key => :refinery_page_id

    validates :title, :presence => true
    alias_attribute :content, :body

    translates :body if respond_to?(:translates)

    def to_param
      "page_part_#{title.downcase.gsub(/\W/, '_')}"
    end

    before_save :normalise_text_fields

    self.translation_class.send :attr_accessible, :locale if self.respond_to?(:translation_class)

  protected
    def normalise_text_fields
      if body.present? && body !~ /^\</
        self.body = "<p>#{body.gsub("\r\n\r\n", "</p><p>").gsub("\r\n", "<br/>")}</p>"
      end
    end

  end
end
