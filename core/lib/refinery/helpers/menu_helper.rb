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
      def css_for_menu_branch(menu_branch, menu_branch_counter, sibling_count = nil, collection = nil, selected_item = nil, warning = true)
        # DEPRECATION. Remove at version 1.1
        if warning
          warn "\n-- DEPRECATION WARNING --"
          warn "The use of 'css_for_menu_branch' is deprecated and will be removed at version 1.1."
          warn "Please use menu_branch_css(local_assigns) instead."
          warn "Called from: #{caller.detect{|c| c =~ %r{#{Rails.root.to_s}}}.inspect.to_s.split(':in').first}\n\n"
        end

        if collection
          warn "\n-- DEPRECATION WARNING --"
          warn "The use of 'collection' is deprecated and will be removed at version 1.1."
          warn "Called from: #{caller.detect{|c| c =~ %r{#{Rails.root.to_s}}}.inspect.to_s.split(':in').first}\n\n"
        end

        if selected_item
          warn "\n-- DEPRECATION WARNING --"
          warn "The use of 'selected_item' is deprecated and will be removed at version 1.1."
          warn "Called from: #{caller.detect{|c| c =~ %r{#{Rails.root.to_s}}}.inspect.to_s.split(':in').first}\n\n"
        end

        css = []
        css << "selected" if selected_page_or_descendant_page_selected?(menu_branch, collection, selected_item)
        css << "first" if menu_branch_counter == 0
        css << "last" if (sibling_count ? (menu_branch_counter == sibling_count - 1) : (menu_branch.rgt == menu_branch.parent.rgt - 1))
        css
      end

      # New method which accepts the local_assigns hash.
      # This maps to the older css_for_menu_branch method.
      def menu_branch_css(local_assigns)
        options = local_assigns.dup
        options.update(:sibling_count => options[:menu_branch].shown_siblings.size) unless options[:sibling_count]

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
        if defined?(::Refinery::I18n) and ::Refinery::I18n.enabled? and path =~ %r{^/#{::I18n.locale}/}
          path = path.split(%r{^/#{::I18n.locale}}).last
          path = "/" if path.blank?
        end

        # Match path based on cascading rules.
        (path =~ Regexp.new(page.menu_match) if page.menu_match.present?) or
          path == page.link_url or
          path == page.nested_path or
          URI.decode(path) == page.nested_path or
          path == "/#{page.id}" or
          current_page?(page)
      end

    end
  end
end
