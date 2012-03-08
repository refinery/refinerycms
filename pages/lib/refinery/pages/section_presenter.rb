module Refinery
  module Pages
    # Knows how to build the html for a section. A section is part of the visible html, that has
    # content wrapped in some particular markup. Construct with the relevant options, and then
    # call wrapped_html to get the resultant html.
    #
    # The content rendered will usually be the value of fallback_html, unless an override_html
    # is specified. However, on rendering, you can elect not display sections that have no
    # override_html by passing in false for can_use_fallback.
    #
    # Sections may be hidden, in which case they wont display at all.
    class SectionPresenter
      include ActionView::Helpers::TagHelper

      def initialize(initial_hash = {})
        initial_hash.map do |key, value|
          send("#{key}=", value)
        end
      end

      attr_reader :id, :fallback_html, :hidden
      alias_method :hidden?, :hidden
      attr_accessor :override_html

      def visible?
        !hidden?
      end

      def has_content?(can_use_fallback = true)
        visible? && content_html(can_use_fallback).present?
      end

      def wrapped_html(can_use_fallback = true)
        return if hidden?

        content = content_html(can_use_fallback)
        if content.present?
          wrap_content_in_tag(content)
        end
      end

      def hide
        self.hidden = true
      end

      def not_present_css_class
        "no_#{id}"
      end

    protected

      def content_html(can_use_fallback)
        if override_html.present?
          override_html
        else
          html_from_fallback(can_use_fallback)
        end
      end

      def html_from_fallback(can_use_fallback)
        fallback_html if fallback_html.present? && can_use_fallback
      end

    private

      attr_writer :id, :fallback_html, :hidden

      def wrap_content_in_tag(content)
        content_tag(:section, content_tag(:div, content, :class => 'inner'), :id => id)
      end
    end
  end
end
