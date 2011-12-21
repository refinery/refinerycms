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
            if page_name =~ /the page titled "?([^\"]*)"? with locale "?([^\"]*)"?/ and (page = Page.by_title($1).first).present?
              self.url_for(page.url.is_a?(String) ? "/#{$2}#{page.url}" : page.url.merge(:locale => $2))
            elsif page_name =~ /the page titled "?([^\"]*)"?/ and (page = Page.by_title($1).first).present?
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
