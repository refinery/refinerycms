module Refinery
  module Pages
    module InstanceMethods

      def error_404(exception=nil)
        if (@page = ::Refinery::Page.where(:menu_match => "^/404$").includes(:parts).first).present?
          # render the application's custom 404 page with layout and meta.
          render :template => '/refinery/pages/show', :formats => [:html], :status => 404
          return false
        else
          super
        end
      end

    protected
      def find_pages_for_menu
        # Compile the menu
        @menu_pages = ::Refinery::Menu.new(::Refinery::Page.fast_menu)
      end

      def render(*args)
        present(@page) unless admin? or @meta.present?
        super
      end

    private
      def store_current_location!
        return super if admin?

        session[:website_return_to] = refinery.url_for(@page.url) if @page && @page.persisted?
      end

    end
  end
end
