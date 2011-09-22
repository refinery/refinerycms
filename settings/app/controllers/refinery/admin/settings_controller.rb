module ::Refinery
  module Admin
    class SettingsController < ::Refinery::AdminController

      helper "refinery/admin/settings"

      crudify :'refinery/setting',
              :order => "name ASC",
              :redirect_to_url => :redirect_to_where?,
              :xhr_paging => true

      before_filter :sanitise_params, :only => [:create, :update]
      after_filter :fire_setting_callback, :only => [:update]

      def new
        form_value_type = ((current_refinery_user.has_role?(:superuser) && params[:form_value_type]) || 'text_area')
        @setting = ::Refinery::Setting.new(:form_value_type => form_value_type)
      end

      def edit
        @setting = ::Refinery::Setting.find(params[:id])

        render :layout => false if request.xhr?
      end

    protected
      def find_all_settings
        @settings = ::Refinery::Setting.order('name ASC')

        unless current_refinery_user.has_role?(:superuser)
          @settings = @settings.where("restricted <> ? ", true)
        end

        @settings
      end

      def search_all_settings
        # search for settings that begin with keyword
        term = "^" + params[:search].to_s.downcase.gsub(' ', '_')

        # First find normal results, then weight them with the query.
         @settings = find_all_settings.with_query(term)
      end

    private
      def redirect_to_where?
        (from_dialog? && session[:return_to].present?) ? session[:return_to] : main_app.refinery_admin_settings_path
      end

      # this fires before an update or create to remove any attempts to pass sensitive arguments.
      def sanitise_params
        params.delete(:callback_proc_as_string)
        params.delete(:scoping)
      end

      def fire_setting_callback
        begin
          @setting.callback_proc.call
        rescue
          logger.warn('Could not fire callback proc. Details:')
          logger.warn(@setting.inspect)
          logger.warn($!.message)
          logger.warn($!.backtrace)
        end unless @setting.callback_proc.nil?
      end

    end
  end
end
