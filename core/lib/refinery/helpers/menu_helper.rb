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
      def css_for_menu_branch(menu_branch, menu_branch_counter, sibling_count = nil, collection = [], selected_item = nil, warning = true)
        # DEPRECATION. Remove at version 1.1
        if warning
          warn "\n-- DEPRECATION WARNING --"
          warn "The use of 'css_for_menu_branch' is deprecated."
          warn "Please use menu_branch_css(local_assigns) instead."
          warn "Called from: #{caller.detect{|c| c =~ %r{#{Rails.root.to_s}}}.inspect.to_s.split(':in').first}\n\n"
        end

        css = []
        css << "selected" if selected_page_or_descendant_page_selected?(menu_branch, collection, selected_item)
        css << "first" if menu_branch_counter == 0
        css << "last" if menu_branch_counter == sibling_count
        css
      end

      # New method which accepts the local_assigns hash.
      # This maps to the older css_for_menu_branch method.
      def menu_branch_css(local_assigns)
        options = {:collection => []}.merge(local_assigns)
        if options.keys.exclude?(:sibling_count) || options[:sibling_count].nil?
          options.update(:sibling_count => options[:menu_branch].shown_siblings.size)
        end
        css_for_menu_branch(options[:menu_branch],
                            options[:menu_branch_counter],
                            options[:sibling_count],
                            options[:collection],
                            options[:selected_item],
                            false)
      end

      # Determines whether any page underneath the supplied page is the current page according to rails.
      # Just calls selected_page? for each descendant of the supplied page.
      # if you pass a collection it won't check its own descendants but use the collection supplied.
      def descendant_page_selected?(page, collection = [], selected_item = nil)
        return false unless page.has_descendants? or (selected_item && !selected_item.in_menu?)

        descendants = if collection.present? and (!selected_item or (selected_item && selected_item.in_menu?))
          collection.select{ |item| item.parent_id == page.id }
        else
          page.descendants
        end

        descendants.any? do |descendant|
          selected_item ? selected_item == descendant : selected_page?(descendant)
        end
      end

      def selected_page_or_descendant_page_selected?(page, collection = [], selected_item = nil)
        selected = false
        selected = selected_item ? selected_item === page : selected_page?(page)
        selected = descendant_page_selected?(page, collection, selected_item) unless selected
        selected
      end

      # Determine whether the supplied page is the currently open page according to Refinery.
      # Also checks whether Rails thinks it is selected after that using current_page?
      def selected_page?(page)
        path = request.path

        # Ensure we match the path without the locale, if present.
        if defined?(::Refinery::I18n) and ::Refinery::I18n.enabled? and path =~ %r{^/#{::I18n.locale}}
          path = path.split(%r{^/#{::I18n.locale}}).last
          path = "/" if path.blank?
        end

        # Match path based on cascading rules.
        (path =~ Regexp.new(page.menu_match) if page.menu_match.present?) or
          (path == page.link_url) or
          (path == page.nested_path) or
          current_page?(page)
      end

    end
  end
end
