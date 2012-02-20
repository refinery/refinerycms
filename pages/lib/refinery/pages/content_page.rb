module Refinery
  module Pages
    class ContentPage
      def self.build_for_page(page, page_title)
        sections = self.new
        sections.add_default_title_section(page_title) if page_title.present?
        sections.add_page_parts(page.parts) if page
        sections.add_default_post_page_sections
        sections
      end

      def initialize(initial_sections = [])
        @sections = initial_sections
      end

      def blank_section_css_classes(allowed_to_use_fallback)
        @sections.reject {|section| section.has_content?(allowed_to_use_fallback)}.map(&:not_present_css_class)
      end

      def add_default_title_section(title)
        add_section SectionPresenter.new(:id => :body_content_title, :fallback_html => title, :title => true)
      end

      def add_default_post_page_sections
        add_section_if_missing(:id => :body_content_left)
        add_section_if_missing(:id => :body_content_right)
      end

      def hide_sections(ids_to_hide)
        @sections.select {|section| ids_to_hide.include?(section.id)}.each(&:hide)
      end

      def add_page_parts(parts)
        parts.each do |part|
          add_section SectionPresenter.from_page_part(part)
        end
      end

      def fetch_template_overrides
        @sections.each do |section|
          if section.id.present?
            section.override_html = yield section.id
          end
        end
      end

      def add_section(new_section)
        @sections << new_section
      end

      def get_section(index)
        @sections[index]
      end

      def to_html(allowed_to_use_fallback = true)
        @sections.map {|section| section.wrapped_html(allowed_to_use_fallback)}.join("\n").html_safe
      end

      private

        def add_section_if_missing(options)
          add_section SectionPresenter.new(options) unless has_section?(options[:id])
        end

        def has_section?(id)
          @sections.detect {|section| section.id == id}
        end
    end
  end
end