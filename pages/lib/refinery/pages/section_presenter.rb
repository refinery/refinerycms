module Refinery
  module Pages
    class SectionPresenter
      include ActionView::Helpers::TagHelper

      def self.from_page_part(part)
        self.new(:fallback_html => part.body, :title_symbol => part.title.to_s.gsub(/\ /, '').underscore.to_sym)
      end

      def initialize(initial_hash = {})
        initial_hash.map do |key, value|
          send("#{key}=", value)
        end
      end

      attr_reader :id, :fallback_html, :title, :hidden
      alias_method :title?, :title
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
          if title?
            content_tag(:h1, content, :id => id)
          else
            content_tag(:section, content_tag(:div, content, :class => 'inner'), :id => id)
          end
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

        def title_symbol=(value)
          self.id = case value
          when :body then :body_content_left
          when :side_body then :body_content_right
          else value
          end
        end

      private

        attr_writer :id, :fallback_html, :title, :hidden
    end
  end
end