class UsersController < ApplicationController

  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :reject_signup_if_disabled, :only => [:new, :create]

  filter_parameter_logging 'password', 'password_confirmation'

  layout 'admin'

  def create
    begin
      cookies.delete :auth_token
      # protects against session fixation attacks, wreaks havoc with
      # request forgery protection.
      # uncomment at your own risk
      # reset_session
      @user = User.new(params[:user])
      @selected_plugin_names = params[:user][:plugins] || []

      @user.register! if @user.valid?
      if @user.errors.empty?
        @user.plugins = @selected_plugin_names
        self.current_user = @user
        current_user.activate!
        current_user.update_attribute(:superuser, true) if User.count == 1 # this is the superuser if this user is the only user.
        redirect_back_or_default(admin_root_url)

        flash[:notice] = t('users.create.welcome', :who => current_user.login)
        if User.count == 1 or RefinerySetting[:site_name] == "Company Name"
          refinery_setting = RefinerySetting.find_by_name("site_name")
          flash[:notice] << t('users.setup_website_name', :link => edit_admin_refinery_setting_url(refinery_setting))
        end
      else
        render :action => 'new'
      end
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = t('.signup_complete')
    end
    redirect_back_or_default(root_url)
  end

  def suspend
    @user.suspend!
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend!
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

protected
  def take_down_for_maintenance?;end

  def find_user
    @user = User.find(params[:id])
  end

  def can_create_public_user
    User.count == 0
  end

  def reject_signup_if_disabled
    render :text => t('users.signup_disabled'), :layout => true unless can_create_public_user
  end

end
