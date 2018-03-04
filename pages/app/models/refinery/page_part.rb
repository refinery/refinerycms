module Refinery
  class PagePart < Refinery::Core::BaseModel

    belongs_to :page, :foreign_key => :refinery_page_id, :touch => true

    before_validation :set_default_slug

    validates :title, :presence => true
    validates :slug, :presence => true, :uniqueness => {:scope => :refinery_page_id}
    alias_attribute :content, :body

    translates :body

    attribute :body

    def to_param
      "page_part_#{slug.downcase.gsub(/\W/, '_')}"
    end

    def body=(value)
      write_attribute(:body, value)

      normalise_text_fields
    end

    def slug_matches?(other_slug)
      slug.present? && (# protecting against the problem that occurs when have two nil slugs
        slug == other_slug.to_s ||
        parameterized_slug == parameterize(other_slug.to_s)
      )
    end

    protected

    def normalise_text_fields
      if read_attribute(:body).present? && read_attribute(:body) !~ %r{^<}
        write_attribute(:body, "<p>#{read_attribute(:body).gsub("\r\n\r\n", "</p><p>").gsub("\r\n", "<br/>")}</p>")
      end
    end

    private
    def parameterize(string)
      string.downcase.gsub(" ", "_")
    end

    def parameterized_slug
      parameterize(slug)
    end

    def set_default_slug
      self.slug = title.to_s.parameterize.underscore.presence if self.slug.blank?
    end
  end
end
