module Refinery
  module Admin
    class PagesController < Refinery::AdminController
      prepend Pages::InstanceMethods

      crudify :'refinery/page',
              :include => [:translations, :children],
              :paging => false

      helper_method :valid_layout_templates, :valid_view_templates

      def new
        @page = Page.new(new_page_params)
        Pages.default_parts_for(@page).each_with_index do |page_part, index|
          @page.parts << PagePart.new(:title => page_part[:title], :slug => page_part[:slug], :position => index)
        end
      end

      def children
        @page = find_page
        render :layout => false
      end

      def update
        if @page.update_attributes(page_params)
          flash.notice = t('refinery.crudify.updated', what: "'#{@page.title}'")

          if from_dialog?
            self.index
            @dialog_successful = true
            render :index
          else
            if params[:continue_editing] =~ /true|on|1/
              if request.xhr?
                render partial: 'save_and_continue_callback',
                       locals: save_and_continue_locals(@page)
              else
                redirect_to :back
              end
            else
              redirect_back_or_default(refinery.admin_pages_path)
            end
          end
        else
          if request.xhr?
            render :partial => '/refinery/admin/error_messages', :locals => {
              :object => @page,
              :include_object_name => true
            }
          else
            render 'edit'
          end
        end
      end

      protected

      def after_update_positions
        find_all_pages
        render :partial => '/refinery/admin/pages/sortable_list' and return
      end

      def find_page
        @page = Page.find_by_path_or_id!(params[:path], params[:id])
      end
      alias_method :page, :find_page

      # We can safely assume ::Refinery::I18n is defined because this method only gets
      # Invoked when the before_action from the plugin is run.
      def globalize!
        return super unless action_name.to_s == 'index'

        # Always display the tree of pages from the default frontend locale.
        if Refinery::I18n.built_in_locales.keys.map(&:to_s).include?(params[:switch_locale])
          Globalize.locale = params[:switch_locale].try(:to_sym)
        else
          Globalize.locale = Refinery::I18n.default_frontend_locale
        end
      end

      def valid_layout_templates
        Pages.layout_template_whitelist & Pages.valid_templates(*Pages.layout_templates_pattern)
      end

      def valid_view_templates
        Pages.valid_templates(*Pages.view_templates_pattern)
      end

      def page_params
        params.require(:page).permit(permitted_page_params)
      end

      def new_page_params
        params.permit(:parent_id, :view_template, :layout_template)
      end

      private

      def permitted_page_params
        [
          :browser_title, :draft, :link_url, :menu_title, :meta_description,
          :parent_id, :skip_to_first_child, :show_in_menu, :title, :view_template,
          :layout_template, :custom_slug, parts_attributes: [:id, :title, :slug, :body, :position]
        ]
      end

      def save_and_continue_locals(page)
        nested_url = page.nested_url
        {
          new_refinery_edit_page_path: refinery.admin_edit_page_path(nested_url),
          new_refinery_page_path: refinery.admin_update_page_path(nested_url),
          new_page_path: refinery.pages_admin_preview_page_path(nested_url)
        }
      end
    end
  end
end
