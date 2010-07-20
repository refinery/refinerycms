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

  # This method should only be used to create the first Refinery user.
  def create
    # protects against session fixation attacks, wreaks havoc with request forgery protection.
    # uncomment at your own risk:
    # reset_session
    @user = User.new(params[:user])
    @selected_plugin_titles = params[:user][:plugins] || []

    @user.save if @user.valid?

    if @user.errors.empty?
      @user.add_role(:refinery)
      @user.plugins = @selected_plugin_titles
      @user.save
      UserSession.create!(@user)
      if Role[:refinery].users.count == 1
        # this is the superuser if this user is the only user.
        current_user.add_role(:superuser)
        current_user.save

        # set this user as the recipient of inquiry notifications
        if (notification_recipients = InquirySetting.find_or_create_by_name("Notification Recipients")).present?
          notification_recipients.update_attributes({
            :value => current_user.email,
            :destroyable => false
          })
        end
      end

      flash[:message] = "<h2>#{t('users.create.welcome', :who => current_user.login).gsub(/\.$/, '')}.</h2>".html_safe

      site_name_setting = RefinerySetting.find_or_create_by_name('site_name', :value => "Company Name")
      if site_name_setting.value.to_s =~ /^(|Company\ Name)$/ or Role[:refinery].users.count == 1
        flash[:message] << "<p>#{t('users.setup_website_name',
                                   :link => edit_admin_refinery_setting_url(site_name_setting, :dialog => true),
                                   :title => t('admin.refinery_settings.refinery_setting.edit'))}</p>".html_safe
      end

      redirect_back_or_default(admin_root_url)
    else
      render :action => 'new'
    end
  end

  def forgot
    if request.post?
      if (params[:user].present? and params[:user][:email].present? and
          user = User.find_by_email(params[:user][:email])).present?
        user.deliver_password_reset_instructions!(request)
        flash[:notice] = t('users.forgot.email_reset_sent')
        redirect_back_or_default new_session_url
      else
        @user = User.new(params[:user])
        if (email = params[:user][:email]).blank?
          flash.now[:error] = t('users.forgot.blank_email')
        else
          flash.now[:error] = t('users.forgot.email_not_associated_with_account',
                                :email => params[:user][:email])
        end
      end
    end
  end

  def reset
    if params[:reset_code] and @user = User.find_using_perishable_token(params[:reset_code])
      if request.post?
        UserSession.create(@user)
        if @user.update_attributes(:password => params[:user][:password],
                                   :password_confirmation => params[:user][:password_confirmation])

          flash[:notice] = t('users.reset.successful', :email => @user.email)
          redirect_back_or_default admin_root_url
        end
      end
    else
      redirect_to(forgot_users_url, :error => t('users.reset.code_invalid'))
    end
  end

protected

  def redirect?
    if refinery_user?
      redirect_to admin_users_url
    elsif refinery_users_exist?
      redirect_to root_url
    end
  end

  def refinery_users_exist?
    Role[:refinery].users.any?
  end

end
