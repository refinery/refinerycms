module Refinery
  module Pages
    module Admin
      class PreviewController < Refinery::PagesController
        include ::Refinery::ApplicationController
        helper ApplicationHelper
        helper Refinery::Core::Engine.helpers
        include Refinery::Admin::BaseController
        include Pages::RenderOptions

        skip_before_action :error_404, :set_canonical

        def show
          render_with_templates?
        end

        protected

        def admin?
          false
        end

        def find_page
          if @page = Refinery::Page.find_by_path_or_id(params[:path], params[:id])
            # Preview existing pages
            @page.attributes = page_params
          elsif params[:page]
            # Preview a non-persisted page
            @page = Page.new page_params
          end
        end
        alias_method :page, :find_page

        def page_params
          params.require(:page).permit(permitted_page_params)
        end

        private

        def permitted_page_params
          [
            :browser_title, :draft, :link_url, :menu_title, :meta_description,
            :parent_id, :skip_to_first_child, :show_in_menu, :title, :view_template,
            :layout_template, :custom_slug, parts_attributes: [:id, :title, :slug, :body, :position]
          ]
        end
      end
    end
  end
end
