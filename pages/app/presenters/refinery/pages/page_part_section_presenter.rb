module Refinery
  module Pages
    # A type of SectionPresenter which knows how to render a section which displays
    # a PagePart model.
    class PagePartSectionPresenter < SectionPresenter
      def initialize(page_part)
        super()
        self.fallback_html = page_part.body.html_safe if page_part.body
        self.id = page_part.slug.to_sym if page_part.slug
      end
    end
  end
end
