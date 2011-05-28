module NavigationHelpers
  module Refinery
    module Settings
      def path_to(page_name)
        case page_name
        when /the list of (?:|refinery )settings/
          refinery_admin_settings_path
        else
          nil
        end
      end
    end
  end
end
