module NavigationHelpers
  module Refinery
    module Pages
      def path_to(page_name)
        case page_name
        when /the home\s?page/
          root_path
        when /the list of pages/
          refinery_admin_pages_path
        when /the new page form/
          new_refinery_admin_page_path
        else
          begin
            if page_name =~ /the page titled "?([^\"]*)"?/ and (page = ::Refinery::Page.by_title($1).first).present?
              self.url_for(page.url)
            else
              nil
            end
          rescue
            nil
          end
        end
      end
    end
  end
end
