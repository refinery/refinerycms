require 'active_support/core_ext/string'
require 'active_support/configurable'
require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'

module Refinery
  module Pages
    class MenuPresenter
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include ActiveSupport::Configurable

      config_accessor :roots, :menu_tag, :menu_role, :list_tag, :list_item_tag, :css, :dom_id,
                      :max_depth, :active_css, :selected_css, :first_css, :last_css, :list_tag_css,
                      :link_tag_css
      self.dom_id = 'menu'
      self.css = 'menu clearfix'
      self.menu_tag = :nav
      self.list_tag = :ul
      self.list_item_tag = :li
      self.active_css = :active
      self.selected_css = :selected
      self.first_css = :first
      self.last_css = :last
      self.list_tag_css = 'nav'

      def roots
        config.roots.presence || collection.roots
      end

      attr_accessor :context, :collection
      delegate :output_buffer, :output_buffer=, :to => :context

      def initialize(collection, context)
        @collection = collection
        @context = context
      end

      def to_html
        render_menu(roots) if roots.present?
      end

      private
      def render_menu(items)
        content_tag(menu_tag, id: dom_id, class: css, role: menu_role) do
          render_menu_items(items)
        end
      end

      def render_menu_items(menu_items)
        if menu_items.present?
          content_tag(list_tag, :class => list_tag_css) do
            menu_items.each_with_index.inject(ActiveSupport::SafeBuffer.new) do |buffer, (item, index)|
              buffer << render_menu_item(item, index)
            end
          end
        end
      end

      def render_menu_item_link(menu_item)
        link_to(menu_item.title, context.refinery.url_for(menu_item.url), :class => link_tag_css)
      end

      def render_menu_item(menu_item, index)
        content_tag(list_item_tag, :class => menu_item_css(menu_item, index)) do
          buffer = ActiveSupport::SafeBuffer.new
          buffer << render_menu_item_link(menu_item)
          buffer << render_menu_items(menu_item_children(menu_item))
          buffer
        end
      end

      # Determines whether any item underneath the supplied item is the current item according to rails.
      # Just calls selected_item? for each descendant of the supplied item
      # unless it first quickly determines that there are no descendants.
      def descendant_item_selected?(item)
        item.has_children? && item.descendants.any?(&method(:selected_item?))
      end

      # Determine whether the supplied item is the currently open item according to Refinery.
      def selected_item?(item)
        # Ensure we match the path without the locale, if present.
        path = match_locale_for(encoded_path)

        # First try to match against a "menu match" value, if available.
        return true if menu_match_is_available?(item, path)

        # Find the first url that is a string.
        url = find_url_for(item)

        # Now use all possible vectors to try to find a valid match
        [path, URI.decode(path)].include?(url) || path == "/#{item.original_id}"
      end

      def menu_item_css(menu_item, index)
        css = []

        css << active_css if descendant_item_selected?(menu_item)
        css << selected_css if selected_item?(menu_item)
        css << first_css if index == 0
        css << last_css if index == menu_item.shown_siblings.length

        css.reject(&:blank?).presence
      end

      def menu_item_children(menu_item)
        within_max_depth?(menu_item) ? menu_item.children : []
      end

      def within_max_depth?(menu_item)
        !max_depth || menu_item.depth < max_depth
      end

      def encoded_path
        path = context.request.path
        path.force_encoding('utf-8') if path.respond_to?(:force_encoding)
        path
      end

      def match_locale_for(path)
        if %r{^/#{::I18n.locale}/} === path
          path.split(%r{^/#{::I18n.locale}}).last.presence || "/"
        else
          path
        end
      end

      def menu_match_is_available?(item, path)
        item.try(:menu_match).present? && path =~ Regexp.new(item.menu_match)
      end

      def find_url_for(item)
        url = [item.url]
        url << ['', item.url[:path]].compact.flatten.join('/') if item.url.respond_to?(:keys)
        url.last.match(%r{^/#{::I18n.locale.to_s}(/.*)}) ? $1 : url.detect{ |u| u.is_a?(String) }
      end
    end
  end
end