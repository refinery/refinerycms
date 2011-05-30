module NavigationHelpers
  module Refinery
    module Core
      def path_to(page_name)
        case page_name
          when /the admin dialog for links path/
            refinery_admin_dialog_path('Link')
          when /the admin dialog for images path/
            refinery_admin_dialog_path('Image')
          when /the admin dialog for empty iframe src/
            refinery_admin_dialog_path('a')
          else
            nil
        end
      end
    end
  end
end
