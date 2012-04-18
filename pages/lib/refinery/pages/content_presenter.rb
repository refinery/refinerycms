module Refinery
  module Pages
    # Knows how to render a set of sections as html. This can be used in any
    # Refinery view that is built from a group of sections. Pass the sections
    # into the constructor or call add_section on the instance, then render by
    # calling 'to_html'.
    class ContentPresenter
      include ActionView::Helpers::TagHelper

      def initialize(initial_sections = [])
        @sections = initial_sections
      end

      def blank_section_css_classes(can_use_fallback = true)
        @sections.reject {|section| section.has_content?(can_use_fallback)}.map(&:not_present_css_class)
      end

      def hide_sections(*ids_to_hide)
        ids_to_hide.flatten!
        @sections.select {|section| ids_to_hide.include?(section.id)}.each(&:hide) if ids_to_hide.any?
      end

      def hidden_sections
        @sections.select {|section| section.hidden? }
      end

      def fetch_template_overrides
        @sections.each do |section|
          section.override_html = yield section.id if section.id.present?
        end
      end

      def add_section(new_section)
        @sections << new_section
      end

      def get_section(index)
        @sections[index]
      end

      def to_html(can_use_fallback = true)
        content_tag :section, sections_html(can_use_fallback),
                    :id => 'body_content',
                    :class => blank_section_css_classes(can_use_fallback).join(' ')
      end

    private

      def sections_html(can_use_fallback)
        @sections.map { |section| section.wrapped_html(can_use_fallback) }.compact.join("\n").html_safe
      end

      def add_section_if_missing(options)
        add_section SectionPresenter.new(options) unless has_section?(options[:id])
      end

      def has_section?(id)
        @sections.detect {|section| section.id == id}
      end
    end
  end
end
