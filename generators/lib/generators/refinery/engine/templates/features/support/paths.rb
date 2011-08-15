module NavigationHelpers
  module Refinery
    module <%= class_name.pluralize %><%= 'Engine' if plural_name == singular_name %>
      def path_to(page_name)
        case page_name
        when /the list of <%= plural_name %>/
          admin_<%= plural_name %>_path

         when /the new <%= singular_name %> form/
          new_admin_<%= singular_name %>_path
        else
          nil
        end
      end
    end
  end
end
