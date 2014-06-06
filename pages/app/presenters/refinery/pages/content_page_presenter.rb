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

          # find an instance variable or attribute named for this page part
          section_data = find_data(page, part.title.gsub(/\s+/,""))

          # find a presenter for this attribute/collection?
          section_presenter = find_presenter("Refinery::Pages::#{part.title.capitalize.gsub(/\s+/, "")}SectionPresenter")

          if section_presenter.nil? || section_data.nil?
            # if either presenter/special data is absent default to generic presenter and original part
            section_presenter = PagePartSectionPresenter
            section_data = part
          else
            # augment the data to make it more like a page part
            section_data  = {id: part.title, data:section_data } unless section_data.nil?
          end
          add_section section_presenter.new(section_data) unless section_data.nil?
        end
      end

      def find_presenter(presenter_name)
        presenter_name.constantize if Object.const_defined?(presenter_name)
      end

      def find_data(page, part_name)
        data = page.respond_to?(part_name) ? page.send(part_name) : instance_variable_get('@'+part_name)
      end
    end
  end
end
