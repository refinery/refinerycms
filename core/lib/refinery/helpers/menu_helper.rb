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

      # This was extracted from app/views/shared/_menu_branch.html.erb
      # to remove the complexity of that template by reducing logic in the view.
      def css_for_menu_branch(item, counter, sibling_count = nil, collection = nil, selected_item = nil, warning = true)

        Refinery.deprecate({
          :what => 'css_for_menu_branch',
          :when => '1.1',
          :replacement => 'menu_branch_css(local_assigns)',
          :caller => caller
        }) if warning

        Refinery.deprecate(:what => 'collection', :when => '1.1', :caller => caller) if collection
        Refinery.deprecate(:what => 'selected_item', :when => '1.1', :caller => caller) if selected_item

        css = []
        css << "selected" if selected_page_or_descendant_page_selected?(item, collection, selected_item)
        css << "first" if counter == 0
        css << "last" if counter == (sibling_count ||= (item.shown_siblings.length - 1))
        css
      end

      # New method which accepts the local_assigns hash.
      # This maps to the older css_for_menu_branch method.
      def menu_branch_css(local_assigns)
        options = local_assigns.dup
        options.update(:sibling_count => options[:menu_branch].shown_siblings.length) unless options[:sibling_count]

        css_for_menu_branch(options[:menu_branch],
                            options[:menu_branch_counter],
                            options[:sibling_count],
                            options[:collection],
                            options[:selected_item], # TODO: DEPRECATED, remove at 1.1
                            false)
      end

      # Determines whether any page underneath the supplied page is the current page according to rails.
      # Just calls selected_page? for each descendant of the supplied page.
      # if you pass a collection it won't check its own descendants but use the collection supplied.
      def descendant_page_selected?(page, collection = nil, selected_item = nil)
        return false if page.rgt == page.lft + 1
        return false unless selected_item.nil? or !selected_item.in_menu?

        page.descendants.any? { |descendant|
          !selected_item ? selected_page?(descendant) : selected_item == descendant
        }
      end

      def selected_page_or_descendant_page_selected?(page, collection = nil, selected_item = nil)
        return true if selected_page?(page) || selected_item === page
        return true if descendant_page_selected?(page, collection, selected_item)
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
        url.chomp!('/') if url.size > 1

        # Now use all possible vectors to try to find a valid match,
        # finally passing to rails' "current_page?" method.
        [path, URI.decode(path)].include?(url) || path == "/#{page.id}" || current_page?(page)
      end

    end
  end
end
