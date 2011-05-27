module NavigationHelpers
  module Refinery
    module Core
      def path_to(page_name)
        case page_name
          when /the admin dialog for links path/
            main_app.admin_dialog_path('Link')
          when /the admin dialog for images path/
            main_app.admin_dialog_path('Image')
          when /the admin dialog for empty iframe src/
            main_app.admin_dialog_path('a')
          else
            nil
        end
      end
    end
  end
end
