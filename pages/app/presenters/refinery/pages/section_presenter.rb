require 'diffy'

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
      include ActionView::Helpers::SanitizeHelper

      def initialize(initial_hash = {})
        { logger: Rails.logger }.merge(initial_hash).map do |key, value|
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
        override_html.presence || html_from_fallback(can_use_fallback)
      end

      def html_from_fallback(can_use_fallback)
        fallback_html.presence if can_use_fallback
      end

      private

      attr_accessor :logger
      attr_writer :id, :fallback_html, :hidden

      def wrap_content_in_tag(content)
        content_tag(:section, content_tag(:div, sanitize_content(content), :class => 'inner'), :id => id)
      end

      def sanitize_content(input)
        output = sanitize(input, scrubber: CustomScrubber.new(Refinery::Pages::whitelist_elements,
                                                              Refinery::Pages::whitelist_attributes))

        if input != output
          warning = "\n-- SANITIZED CONTENT WARNING --\n"
          warning << "Refinery::Pages::SectionPresenter#wrap_content_in_tag\n"
          warning << "HTML attributes and/or elements content has been sanitized\n"
          warning << "#{::Diffy::Diff.new(input, output).to_s(:color)}\n"
          logger.warn warning
        end

        return output
      end
    end

    class CustomScrubber < Rails::Html::PermitScrubber
      def initialize(tags, attributes)
        @direction = :bottom_up
        @tags = tags
        @attributes = attributes
      end

      def allowed_node?(node)
        tags.include?(node.name)
      end

      def skip_node?(node)
        node.text?
      end

      def scrub_attribute?(name)
        attributes.exclude?(name) && name !~ /\Adata-[\w-]+\z/
      end

    end
  end
end
