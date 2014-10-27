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
        add_page_parts(page) if page
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

      def add_page_parts(page)
        page.parts.each do |part|

          section_id = convert_title_to_id(part.title)
          section_data = find_data(page, section_id)
          section_presenter = find_presenter("Refinery::Pages::#{section_id.capitalize}SectionPresenter")

          if section_presenter && section_data
          # Add an id to the data so it is sufficiently like a page_part for a presenter to handle it
            section_data  = {id: section_id, data:section_data } unless section_data.blank?
          else
          # default presenter and data
            section_presenter = PagePartSectionPresenter
            section_data = part
          end
          add_section section_presenter.new(section_data) unless section_data.blank?
        end
      end

      def convert_title_to_id(title)
        title.to_s.gsub(/\s/, '').underscore.to_sym
      end

      def find_presenter(presenter_name)
        presenter_name.safe_constantize
      end

      def find_data(page, part_name)
        page.respond_to?(part_name) ? page.send(part_name) : instance_variable_get('@'+part_name.to_s)
      end
    end
  end
end
