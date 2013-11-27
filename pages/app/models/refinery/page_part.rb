module Refinery
  class PagePart < Refinery::Core::BaseModel

    attr_accessible :title, :content, :position, :body, :refinery_page_id
    belongs_to :page, :foreign_key => :refinery_page_id

    validates :title, :presence => true, :uniqueness => {:scope => :refinery_page_id}
    alias_attribute :content, :body

    translates :body

    def to_param
      "page_part_#{title.downcase.gsub(/\W/, '_')}"
    end

    def body=(value)
      super

      normalise_text_fields
    end

    self.translation_class.send :attr_accessible, :locale

    def title_matches?(other_title)
      title.present? and # protecting against the problem that occurs when have nil title
        title == other_title.to_s or
        parameterized_title == parameterize(other_title.to_s)
    end

    protected
    def normalise_text_fields
      if body? && body !~ %r{^<}
        self.body = "<p>#{body.gsub("\r\n\r\n", "</p><p>").gsub("\r\n", "<br/>")}</p>"
      end
    end

    private
    def parameterize(string)
      string.downcase.gsub(" ", "_")
    end

    def parameterized_title
      parameterize(title)
    end
  end
end
