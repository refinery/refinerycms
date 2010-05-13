class UsersController < ApplicationController

  # Protect these actions behind an admin login
  before_filter :redirect?, :only => [:new, :create, :index]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  # authlogic default
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => [:show, :edit, :update]

  filter_parameter_logging 'password', 'password_confirmation'

  layout 'admin'

  def new
    @user = User.new
  end

  def create
    begin
      # protects against session fixation attacks, wreaks havoc with request forgery protection.
      # uncomment at your own risk:
      # reset_session
      @user = User.create(params[:user])
      @selected_plugin_titles = params[:user][:plugins] || []

      @user.save if @user.valid?

      if @user.errors.empty?
        @user.plugins = @selected_plugin_titles
        @user.save
        UserSession.create!(@user)
        if User.count == 1
          # this is the superuser if this user is the only user.
          current_user.update_attribute(:superuser, true)

          # set this user as the recipient of inquiry notifications
          if (notification_recipients = InquirySetting.find_or_create_by_name("Notification Recipients")).present?
            notification_recipients.update_attributes({
              :value => current_user.email,
              :destroyable => false
            })
          end
        end

        redirect_back_or_default(admin_root_url)
        flash[:notice] = "Welcome to Refinery, #{current_user.login}."

        if User.count == 1 or RefinerySetting[:site_name] == "Company Name"
          refinery_setting = RefinerySetting.find_by_name("site_name")
          flash[:notice] << "<br/>First let's give the site a name. <a href='#{edit_admin_refinery_setting_url(refinery_setting)}'>Go here</a> to edit your website's name"
        end
      else
        render :action => 'new'
      end
    end
  end

  def forgot
    if request.post?
      if (params[:user].present? and params[:user][:email].present? and user = User.find_by_email(params[:user][:email])).present?
        user.deliver_password_reset_instructions!(request)
        flash.now[:notice] = "An email has been sent to #{user.email} with a link to reset your password."
        redirect_back_or_default new_session_url
      else
        @user = User.new(params[:user])
        flash.now[:error] = "Sorry, '#{params[:user][:email]}' isn't associated with any accounts.<br/>Are you sure you typed the correct email address?"
      end
    end
  end

  def reset
    if params[:reset_code] and @user = User.find_using_perishable_token(params[:reset_code])
      if request.post?
        UserSession.create(@user)
        if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
          flash[:notice] = "Password reset successfully for #{@user.email}"
          redirect_back_or_default admin_root_url
        end
      end
    else
      flash[:error] = "We're sorry, but this reset code has expired or is invalid." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to forgot_users_url
    end
  end

protected

  def redirect?
    if logged_in?
      redirect_to admin_users_url
    else
      redirect_to root_url unless can_create_public_user?
    end
  end

  def take_down_for_maintenance?;end

  def can_create_public_user?
    User.count == 0
  end
  alias_method :can_create_public_user, :can_create_public_user?

end
