class UsersController < ApplicationController

  # Protect these actions behind an admin login
  before_filter :redirect?, :only => [:new, :create, :index]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  # authlogic default
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => [:show, :edit, :update]

  layout 'login'

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
        @user.add_role(:superuser)
        @user.save

        # set this user as the recipient of inquiry notifications, if we're using that engine.
        if defined?(InquirySetting) and
          (notification_recipients = InquirySetting.find_or_create_by_name("Notification Recipients")).present?
          notification_recipients.update_attributes({
            :value => @user.email,
            :destroyable => false
          })
        end
      end

      flash[:message] = "<h2>#{t('users.create.welcome', :who => @user.login).gsub(/\.$/, '')}.</h2>".html_safe

      site_name_setting = RefinerySetting.find_or_create_by_name('site_name', :value => "Company Name")
      if site_name_setting.value.to_s =~ /^(|Company\ Name)$/ or Role[:refinery].users.count == 1
        flash[:message] << "<p>#{t('users.setup_website_name',
                                   :link => edit_admin_refinery_setting_url(site_name_setting, :dialog => true),
                                   :title => t('admin.refinery_settings.edit'))}</p>".html_safe
      end

      redirect_back_or_default(admin_root_url)
    else
      render :action => 'new'
    end
  end

  def forgot
    if request.post?
      if params[:user].present? and (email = params[:user][:email]).present? and
          (user = User.find_by_email(email)).present?

        user.deliver_password_reset_instructions!(request)
        redirect_to new_session_url, :notice => t('users.forgot.email_reset_sent')
      else
        @user = User.new(params[:user])
        flash.now[:error] = if (email = params[:user][:email]).blank?
          t('users.forgot.blank_email')
        else
          t('users.forgot.email_not_associated_with_account', :email => email).html_safe
        end
      end
    end
  end

  def reset
    if params[:reset_code] and @user = User.find_using_perishable_token(params[:reset_code])
      if request.post?
        if (params[:user][:password].present? and params[:user][:password_confirmation].present?)
          if @user.update_attributes(:password => params[:user][:password],
                                     :password_confirmation => params[:user][:password_confirmation])

            UserSession.create(@user)

            redirect_to(admin_root_url, :notice => t('users.reset.successful', :email => @user.email))
          else
            render :action => 'reset'
          end
        else
          flash.now[:error] = t('users.reset.password_blank')
        end
      end
    else
      redirect_to(forgot_users_url, :flash => {:error => t('users.reset.code_invalid')})
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
