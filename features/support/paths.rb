module NavigationHelpers
  module Refinery
    module RailsApplicationRoot
      def path_to(page_name)
        case page_name
        when /the list of files/
          refinery_admin_resources_path
        when /the new file form/
          new_refinery_admin_resource_path
        when /the list of images/
          refinery_admin_images_path
        when /the new image form/
          new_refinery_admin_image_path
        when /the list of (?:|refinery )settings/
          refinery_admin_settings_path
        else
          nil
        end
      end
    end
  end
end
