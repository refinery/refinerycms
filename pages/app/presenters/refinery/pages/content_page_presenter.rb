module Refinery
  module Pages
    # A type of ContentPresenter which specifically knows how to render the html
    # for a Refinery::Page object. Pass the page object into the constructor,
    # and it will build sections from the page's parts. The page is not retained
    # internally, so if the page changes, you need to rebuild this ContentPagePresenter.
    class ContentPagePresenter < ContentPresenter
      def initialize(page, page_title)
        super()
        add_default_title_section(page_title) if page_title.present? && Pages.show_title_in_body
        add_page_parts(page.parts) if page
        add_default_post_page_sections
      end

    private

      def add_default_title_section(title)
        add_section TitleSectionPresenter.new(:id => :body_content_title, :fallback_html => title)
      end

      def add_default_post_page_sections
        add_section_if_missing(:id => :body)
        add_section_if_missing(:id => :side_body)
      end

      def add_page_parts(parts)
        parts.each do |part|
          add_section PagePartSectionPresenter.new(part)
        end
      end
    end
  end
end
