module Refinery
  module Pages
    module Admin
      module InstanceMethods

        def error_404(exception = nil)
          if (@page = ::Refinery::Page.where(:menu_match => "^/404$").includes(:parts).first).present?
            params[:action] = 'error_404'
            # change any links in the copy to the Refinery::Core.backend_path
            # and any references to "home page" to "Dashboard"
            # TODO
=begin
            part_symbol = Refinery::Pages.default_parts.first.to_sym
            @page.content_for(part_symbol) = @page.content_for(part_symbol).to_s.gsub(
                                   /href=(\'|\")\/(\'|\")/, "href='#{Refinery::Core.backend_path}'"
                                 ).gsub("home page", "Dashboard")
=end

            render :template => "/refinery/pages/show", :layout => layout?, :status => 404
            return false
          else
            super
          end
        end

      end
    end
  end
end
