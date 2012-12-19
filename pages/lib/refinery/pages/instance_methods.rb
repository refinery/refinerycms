module Refinery
  module Pages
    module InstanceMethods

      def self.included(base)
        base.send :helper_method, :refinery_menu_pages
        base.send :alias_method_chain, :render, :presenters
      end

      def error_404(exception=nil)
        if (@page = ::Refinery::Page.where(:menu_match => "^/404$").includes(:parts).first).present?
          # render the application's custom 404 page with layout and meta.
          if self.respond_to? :render_with_templates?
            render_with_templates? :status => 404
          else
            render :template => '/refinery/pages/show', :formats => [:html], :status => 404
          end
          return false
        else
          super
        end
      end

      # Compiles the default menu.
      def refinery_menu_pages
        Menu.new Page.fast_menu
      end

    protected
      def render_with_presenters(*args)
        present @page unless admin? || @meta
        render_without_presenters(*args)
      end

    end
  end
end
