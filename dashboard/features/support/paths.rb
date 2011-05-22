module NavigationHelpers
  module Refinery
    module Dashboard
      def path_to(page_name)
      case page_name
        when /the (d|D)ashboard/
          refinery_admin_dashboard_path
        else
          nil
        end
      end
    end
  end
end
