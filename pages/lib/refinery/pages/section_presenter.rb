module Refinery
  module Pages
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

      def has_content?(allowed_to_use_fallback)
        visible? && content_html(allowed_to_use_fallback).present?
      end

      def wrapped_html(allowed_to_use_fallback)
        return if hidden?

        content = content_html(allowed_to_use_fallback)
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

        def content_html(allowed_to_use_fallback)
          override_html.present? ? override_html : html_from_fallback(allowed_to_use_fallback)
        end

        def html_from_fallback(allowed_to_use_fallback)
          fallback_html if fallback_html.present? && allowed_to_use_fallback
        end

      private

        attr_writer :id, :fallback_html, :hidden

        def wrap_content_in_tag(content)
          content_tag(:section, content_tag(:div, content, :class => 'inner'), :id => id)
        end
    end
  end
end