module Refinery
  module Pages
    module Admin
      class PreviewController < AdminController
        include Pages::InstanceMethods
        include Pages::RenderOptions

        layout :layout

        def show
          render_with_templates? page, :template => template
        end

        protected
        def admin?
          false
        end

        def find_page
          if @page = Refinery::Page.find_by_path_or_id(params[:path], params[:id])
            # Preview existing pages
            @page.attributes = params[:page]
          elsif params[:page]
            # Preview a non-persisted page
            @page = Page.new params[:page]
          end
        end
        alias_method :page, :find_page

        def layout
          'application'
        end

        def template
          '/refinery/pages/show'
        end
      end
    end
  end
end
