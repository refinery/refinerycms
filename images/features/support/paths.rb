module NavigationHelpers
  module Refinery
    module Images
      def path_to(page_name)
        case page_name
        when /the list of images/
          admin_images_path

         when /the new image form/
          new_admin_image_path
        else
          nil
        end
      end
    end
  end
end
