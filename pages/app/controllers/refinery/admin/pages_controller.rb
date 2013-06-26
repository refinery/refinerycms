module Refinery
  module Admin
    class PagesController < Refinery::AdminController
      include ActionController::Caching::Sweeping
      include Pages::InstanceMethods
      cache_sweeper Pages::PageSweeper

      crudify :'refinery/page',
              :order => "lft ASC",
              :include => [:translations, :children],
              :paging => false

      before_filter :load_valid_templates, :only => [:edit, :new]
      before_filter :restrict_access, :only => [:create, :update, :update_positions, :destroy]
      after_filter proc { Pages::Caching.new().expire! }, :only => :update_positions

      def new
        @page = Page.new(params.except(:controller, :action, :switch_locale))
        Pages.default_parts_for(@page).each_with_index do |page_part, index|
          @page.parts << PagePart.new(:title => page_part, :position => index)
        end
      end

      def children
        @page = find_page
        render :layout => false
      end

      def update
        if @page.update_attributes(params[:page])
          flash.notice = t(
            'refinery.crudify.updated',
            :what => "'#{@page.title}'"
          )

          unless from_dialog?
            unless params[:continue_editing] =~ /true|on|1/
              redirect_back_or_default(refinery.admin_pages_path)
            else
              unless request.xhr?
                redirect_to :back
              else
                render :partial => 'save_and_continue_callback', :locals => {
                  :new_refinery_page_path => refinery.admin_page_path(@page.nested_url),
                  :new_page_path => refinery.pages_admin_preview_page_path(@page.nested_url)
                }
              end
            end
          else
            self.index
            @dialog_successful = true
            render :index
          end
        else
          unless request.xhr?
            render :action => 'edit'
          else
            render :partial => '/refinery/admin/error_messages', :locals => {
              :object => @page,
              :include_object_name => true
            }
          end
        end
      end

    protected

      def after_update_positions
        find_all_pages
        render :partial => '/refinery/admin/pages/sortable_list' and return
      end

      def find_page
        @page = Page.find_by_path_or_id(params[:path], params[:id])
      end
      alias_method :page, :find_page

      # We can safely assume ::Refinery::I18n is defined because this method only gets
      # Invoked when the before_filter from the plugin is run.
      def globalize!
        return super unless action_name.to_s == 'index'

        # Always display the tree of pages from the default frontend locale.
        if Refinery::I18n.built_in_locales.keys.map(&:to_s).include?(params[:switch_locale])
          Globalize.locale = params[:switch_locale].try(:to_sym)
        else
          Globalize.locale = Refinery::I18n.default_frontend_locale
        end
      end

      def load_valid_templates
        @valid_layout_templates = Pages.layout_template_whitelist &
                                  Pages.valid_templates('app', 'views', '{layouts,refinery/layouts}', '*html*')

        @valid_view_templates = Pages.valid_templates('app', 'views', '{pages,refinery/pages}', '*html*')
      end

      def restrict_access
        if current_refinery_user.has_role?(:translator) && !current_refinery_user.has_role?(:superuser) &&
             (params[:switch_locale].blank? || params[:switch_locale] == Refinery::I18n.default_frontend_locale.to_s)
          flash[:error] = t('translator_access', :scope => 'refinery.admin.pages')
          redirect_to refinery.admin_pages_path
        end

        return true
      end

    end
  end
end
