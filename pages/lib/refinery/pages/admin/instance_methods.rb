module Refinery
  module Pages
    module Admin
      module InstanceMethods

        def error_404(exception=nil)
          if (@page = Page.where(:menu_match => "^/404$").includes(:parts, :slugs).first).present?
            params[:action] = 'error_404'
            # change any links in the copy to the admin_root_path
            # and any references to "home page" to "Dashboard"
            part_symbol = Page.default_parts.first.to_sym
            @page[part_symbol] = @page[part_symbol].to_s.gsub(
                                   /href=(\'|\")\/(\'|\")/, "href='#{admin_root_path}'"
                                 ).gsub("home page", "Dashboard")

            render :template => "/pages/show",
                   :layout => layout?,
                   :status => 404
          else
            super
          end
        end

      end
    end
  end
end
