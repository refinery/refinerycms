module Refinery
  module Helpers
    module MenuHelper

      # This was extracted from REFINERY_ROOT/vendor/plugins/refinery/app/views/shared/_menu_branch.html.erb
      # to remove the complexity of that template by reducing logic in the view.
      def css_for_menu_branch(menu_branch, menu_branch_counter, sibling_count = nil)
        css = []
        css << "selected" if selected_page?(menu_branch) or descendant_page_selected?(menu_branch)
        css << "first" if menu_branch_counter == 0
        css << "last" if menu_branch_counter == (sibling_count ||= menu_branch.shown_siblings.size)
        css
      end

      # Determines whether any page underneath the supplied page is the current page according to rails.
      # Just calls selected_page? for each descendant of the supplied page.
      def descendant_page_selected?(page)
        page.has_descendants? and page.descendants.any? {|descendant| selected_page?(descendant) }
      end

      # Determine whether the supplied page is the currently open page according to Refinery.
      # Also checks whether Rails thinks it is selected after that using current_page?
      def selected_page?(page)
        # ensure we match the path without the locale.
        path = request.path
        if defined?(::Refinery::I18n) and ::Refinery::I18n.enabled?
          path = path.split("/#{::I18n.locale}").last
        end

        (path =~ Regexp.new(page.menu_match) if page.menu_match.present?) or
          (path == page.link_url) or
          (path == page.nested_path) or
          current_page?(page)
      end

    end
  end
end
