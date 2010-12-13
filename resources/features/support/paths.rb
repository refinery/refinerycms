module NavigationHelpers
  module Refinery
    module Resources
      def path_to(page_name)
        case page_name
        when /the list of files/
          admin_resources_path

        when /the new file form/
          new_admin_resource_path
        else
          nil
        end
      end
    end
  end
end
