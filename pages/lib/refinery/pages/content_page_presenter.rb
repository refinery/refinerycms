module Refinery
  module Pages
    class ContentPagePresenter < ContentPresenter
      def self.build_for_page(page, page_title)
        self.new(page, page_title)
      end

      def initialize(page, page_title)
        super()
        add_default_title_section(page_title) if page_title.present?
        add_page_parts(page.parts) if page
        add_default_post_page_sections
      end

      private

        def add_default_title_section(title)
          add_section SectionPresenter.new(:id => :body_content_title, :fallback_html => title, :title => true)
        end

        def add_default_post_page_sections
          add_section_if_missing(:id => :body_content_left)
          add_section_if_missing(:id => :body_content_right)
        end

        def add_page_parts(parts)
          parts.each do |part|
            add_section SectionPresenter.from_page_part(part)
          end
        end
    end
  end
end