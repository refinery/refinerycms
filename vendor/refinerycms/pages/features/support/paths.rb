module NavigationHelpers
  module Refinery
    module Pages
      def path_to(page_name)
        case page_name
        when /the home\s?page/
          root_path
        when /the list of pages/
          admin_pages_path
        when /the new page form/
          new_admin_page_path
        else
          nil
        end
      end
    end
  end
end
