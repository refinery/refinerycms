module Refinery
  module Helpers
    module MenuHelper

      # Adds conditional caching
      def cache_if(condition, name = {}, &block)
        if condition
          cache(name, &block)
        else
          yield
        end

        # for <%= style helpers vs <% style
        nil
      end

      # This was extracted from app/views/refinery/_menu_branch.html.erb
      # to remove the complexity of that template by reducing logic in the view.
      def menu_branch_css(local_assigns)
        options = local_assigns.dup
        options.update(:sibling_count => options[:menu_branch].shown_siblings.length) unless options[:sibling_count]

        css = []
        css << 'selected' if selected_page_or_descendant_page_selected?(local_assigns[:menu_branch], local_assigns[:collection])
        css
      end

      # Determines whether any page underneath the supplied page is the current page according to rails.
      # Just calls selected_page? for each descendant of the supplied page.
      # if you pass a collection it won't check its own descendants but use the collection supplied.
      def descendant_page_selected?(page, collection = nil)
        return false if page.rgt == page.lft + 1

        page.descendants.any? { |descendant| selected_page?(descendant) }
      end

      def selected_page_or_descendant_page_selected?(page, collection = nil)
        return true if selected_page?(page)
        return true if descendant_page_selected?(page, collection)
        false
      end

      # Determine whether the supplied page is the currently open page according to Refinery.
      # Also checks whether Rails thinks it is selected after that using current_page?
      def selected_page?(page)
        path = request.path
        path = path.force_encoding('utf-8') if path.respond_to?(:force_encoding)

        # Ensure we match the path without the locale, if present.
        if ::Refinery.i18n_enabled? and path =~ %r{^/#{::I18n.locale}/}
          path = path.split(%r{^/#{::I18n.locale}}).last
          path = "/" if path.blank?
        end

        # First try to match against a "menu match" value, if available.
        return true if page.try(:menu_match).present? && path =~ Regexp.new(page.menu_match)

        # Find the first url that is a string.
        url = [page.url]
        url << ['', page.url[:path]].compact.flatten.join('/') if page.url.respond_to?(:keys)
        url = url.detect{|u| u.is_a?(String)}

        # Now use all possible vectors to try to find a valid match,
        # finally passing to rails' "current_page?" method.
        [path, URI.decode(path)].include?(url) || path == "/#{page.id}"
      end

    end
  end
end
