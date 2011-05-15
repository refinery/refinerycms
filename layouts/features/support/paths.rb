module NavigationHelpers
  module Refinery
    module Layouts
      def path_to(page_name)
        case page_name
        when /the list of layouts/
          admin_layouts_path

         when /the new layout form/
          new_admin_layout_path
        else
          nil
        end
      end
    end
  end
end
