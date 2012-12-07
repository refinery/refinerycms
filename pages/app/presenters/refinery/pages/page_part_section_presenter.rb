module Refinery
  module Pages
    # A type of SectionPresenter which knows how to render a section which displays
    # a PagePart model.
    class PagePartSectionPresenter < SectionPresenter
      def initialize(page_part)
        super()
        self.fallback_html = page_part.body.html_safe if page_part.body
        self.id = convert_title_to_id(page_part.title) if page_part.title
      end

    private

      def convert_title_to_id(title)
        title.to_s.gsub(/\ /, '').underscore.to_sym
      end
    end
  end
end
