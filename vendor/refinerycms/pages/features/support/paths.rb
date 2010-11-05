module NavigationHelpers
  module Refinery
    module Pages
      def path_to(page_name)
        case page_name
        when /the home\s?page/
          root_path
        when /the list of pages/
          admin_pages_path
        when /the new page form/
          new_admin_page_path
        else
          begin
            if page_name =~ /the page titled "?([^\"]*)"?/ and (page = Page.find_by_title($1)).present?
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
