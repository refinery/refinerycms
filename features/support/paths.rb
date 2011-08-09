module NavigationHelpers
  module Refinery
    module RailsApplicationRoot
      def path_to(page_name)
        case page_name
        when /the list of files/
          refinery_admin_resources_path
        when /the new file form/
          new_refinery_admin_resource_path
        else
          nil
        end
      end
    end
  end
end
