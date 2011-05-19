module Refinery
  module Pages
    module InstanceMethods

      def error_404(exception=nil)
        if (@page = ::Page.where(:menu_match => "^/404$").includes(:parts, :slugs).first).present?
          # render the application's custom 404 page with layout and meta.
          render :template => "/pages/show",
                 :format => 'html',
                 :status => 404
        else
          super
        end
      end

    protected
      def find_pages_for_menu
        @menu_pages = ::Page.roots.live.in_menu.order('lft ASC').includes(:children)
      end

      def render(*args)
        present(@page) unless admin? or @meta.present?
        super
      end

    private
      def store_current_location!
        return super if admin?

        session[:website_return_to] = url_for(@page.url) if @page.try(:present?)
      end

    end
  end
end
