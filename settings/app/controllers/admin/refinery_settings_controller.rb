class Admin::RefinerySettingsController < Admin::BaseController

  crudify :refinery_setting,
          :title_attribute => :title,
          :order => "name ASC",
          :searchable => false,
          :redirect_to_url => :redirect_to_where?

  before_filter :sanitise_params, :only => [:create, :update]
  after_filter :fire_setting_callback, :only => [:update]

  def edit
    @refinery_setting = RefinerySetting.find(params[:id])

    render :layout => false if request.xhr?
  end

  def find_all_refinery_settings
    @refinery_settings = RefinerySetting.find(:all,
    {
      :order => "name ASC",
      :conditions => (["restricted <> ?", true] unless current_user.has_role?(:superuser))
    })
  end

  def paginate_all_refinery_settings
    @refinery_settings = RefinerySetting.paginate({
      :page => params[:page],
      :order => "name ASC",
      :conditions => (["restricted <> ?", true] unless current_user.has_role?(:superuser))
    })
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
