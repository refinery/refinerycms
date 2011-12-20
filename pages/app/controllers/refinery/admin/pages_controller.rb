module ::Refinery
  module Admin
    class PagesController < ::Refinery::AdminController
      cache_sweeper ::Refinery::PageSweeper

      crudify :'refinery/page',
              :conditions => nil,
              :order => "lft ASC",
              :redirect_to_url => :'main_app.refinery_admin_pages_path',
              :include => [:slugs, :translations, :children],
              :paging => false

      rescue_from FriendlyId::ReservedError, :with => :show_errors_for_reserved_slug

      after_filter lambda{::Refinery::Page.expire_page_caching}, :only => [:update_positions]

      before_filter :load_valid_templates, :only => [:edit, :new]

      before_filter :restrict_access, :only => [:create, :update, :update_positions, :destroy],
                    :if => proc {|c| ::Refinery.i18n_enabled? }

      def new
        @page = ::Refinery::Page.new(params)
        Refinery::Pages.config.default_parts.each_with_index do |page_part, index|
          @page.parts << ::Refinery::PagePart.new(:title => page_part, :position => index)
        end
      end

    protected

      # We can safely assume ::Refinery::I18n is defined because this method only gets
      # Invoked when the before_filter from the plugin is run.
      def globalize!
        unless action_name.to_s == 'index'
          super

          # Check whether we need to override e.g. on the pages form.
          unless params[:switch_locale] || @page.nil? || @page.new_record? || @page.slugs.where({
            :locale => ::Refinery::I18n.current_locale
          }).empty?
            @page.slug = @page.slugs.first if @page.slug.nil? && @page.slugs.any?
            Thread.current[:globalize_locale] = @page.slug.locale if @page.slug
          end
        else
          # Always display the tree of pages from the default frontend locale.
          Thread.current[:globalize_locale] = params[:switch_locale].try(:to_sym) || ::Refinery::I18n.default_frontend_locale
        end
      end

      def load_valid_templates
        @valid_layout_templates = Refinery::Pages.config.layout_template_whitelist &
                                  Refinery::Pages.valid_templates('app', 'views', '{layouts,refinery/layouts}', '*html*')

        @valid_view_templates = Refinery::Pages.config.view_template_whitelist &
                                Refinery::Pages.valid_templates('app', 'views', '{pages,refinery/pages}', '*html*')
      end

      def restrict_access
        if current_refinery_user.has_role?(:translator) && !current_refinery_user.has_role?(:superuser) &&
             (params[:switch_locale].blank? || params[:switch_locale] == ::Refinery::I18n.default_frontend_locale.to_s)
          flash[:error] = t('translator_access', :scope => 'refinery.admin.pages')
          redirect_to main_app.url_for(:action => 'index') and return
        end

        return true
      end

      def show_errors_for_reserved_slug(exception)
        flash[:error] = t('reserved_system_word', :scope => 'refinery.admin.pages')
        if action_name == 'update'
          find_page
          render :edit
        else
          @page = ::Refinery::Page.new(params[:page])
          render :new
        end
      end
    end
  end
end
