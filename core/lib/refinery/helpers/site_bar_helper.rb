module Refinery
  module Helpers
    module SiteBarHelper

      # Generates the link to determine where the site bar switch button returns to.
      def site_bar_switch_link
        link_to_if(admin?, t('.switch_to_your_website'),
                  (if session.keys.include?(:website_return_to) and session[:website_return_to].present?
                    session[:website_return_to]
                   else
                    root_path
                   end)) do
          link_to t('.switch_to_your_website_editor'),
                  (if session.keys.include?(:refinery_return_to) and session[:refinery_return_to].present?
                    session[:refinery_return_to]
                   elsif defined?(@page) and @page.present? and !@page.home?
                     edit_admin_page_path(@page)
                   else
                     (request.fullpath.to_s == '/') ? admin_root_path : "/refinery#{request.fullpath}/edit"
                   end rescue admin_root_path)
        end
      end

    end
  end
end
