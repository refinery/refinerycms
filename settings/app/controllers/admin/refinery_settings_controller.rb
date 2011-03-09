module Admin
  class RefinerySettingsController < Admin::BaseController

    helper :refinery_settings

    crudify :refinery_setting,
            :title_attribute => :title,
            :order => "name ASC",
            :redirect_to_url => :redirect_to_where?,
            :xhr_paging => true

    before_filter :sanitise_params, :only => [:create, :update]
    after_filter :fire_setting_callback, :only => [:update]

    def new
      if current_user.has_role?(:superuser) and params[:form_value_type].present?
        @refinery_setting = RefinerySetting.new(:form_value_type => params[:form_value_type])
      else
        @refinery_setting = RefinerySetting.new(:form_value_type => 'text_area')
      end
    end

    def edit
      @refinery_setting = RefinerySetting.find(params[:id])

      render :layout => false if request.xhr?
    end

  protected
    def find_all_refinery_settings
      @refinery_settings = RefinerySetting.order('name ASC')

      unless current_user.has_role?(:superuser)
        @refinery_settings = @refinery_settings.where("restricted <> ? ", true)
      end

      @refinery_settings
    end

    def search_all_refinery_settings
      # search for settings that begin with keyword
      term = "^" + params[:search].to_s.downcase.gsub(' ', '_')

      # First find normal results, then weight them with the query.
       @refinery_settings = find_all_refinery_settings.with_query(term)
    end

  private
    def redirect_to_where?
      (from_dialog? && session[:return_to].present?) ? session[:return_to] : admin_refinery_settings_url
    end

    # this fires before an update or create to remove any attempts to pass sensitive arguments.
    def sanitise_params
      params.delete(:callback_proc_as_string)
      params.delete(:scoping)
    end

    def fire_setting_callback
      begin
        @refinery_setting.callback_proc.call
      rescue
        logger.warn('Could not fire callback proc. Details:')
        logger.warn(@refinery_setting.inspect)
        logger.warn($!.message)
        logger.warn($!.backtrace)
      end unless @refinery_setting.callback_proc.nil?
    end

  end
end
