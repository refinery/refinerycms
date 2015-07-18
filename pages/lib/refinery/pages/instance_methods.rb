module Refinery
  module Pages
    module InstanceMethods

      def error_404(exception = nil)
        if (@page = ::Refinery::Page.where(:menu_match => "^/404$").includes(:parts).first).present?
          # render the application's custom 404 page with layout and meta.
          if self.respond_to? :render_with_templates?, true
            render_with_templates? @page, :status => 404
          else
            render :template => '/refinery/pages/show', :formats => [:html], :status => 404
          end
          return false
        else
          super
        end
      end

      def render(*args)
        present @page unless admin? || @meta
        super
      end

    end
  end
end
