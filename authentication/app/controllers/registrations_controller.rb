class RegistrationsController < Devise::RegistrationsController

  # Protect these actions behind an admin login
  before_filter :redirect?, :only => [:new, :create]

  layout 'login'

  def new
    @user = User.new
  end

  # This method should only be used to create the first Refinery user.
  def create
    @user = User.new(params[:user])
    @selected_plugin_titles = params[:user][:plugins] || []

    @user.save if @user.valid?

    if @user.errors.empty?
      @user.add_role(:refinery)
      @user.plugins = @selected_plugin_titles
      @user.save
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
        flash[:message] << "<p>#{t('users.setup_website_name_html',
                                   :link => edit_admin_refinery_setting_url(site_name_setting, :dialog => true),
                                   :title => t('admin.refinery_settings.edit'))}</p>".html_safe
      end
      sign_in(@user)
      redirect_back_or_default(admin_root_url)
    else
      render :action => 'new'
    end
  end

protected

  def redirect?
    if refinery_user?
      redirect_to admin_users_url
    elsif refinery_users_exist?
      redirect_to new_user_session_url
    end
  end

  def refinery_users_exist?
    Role[:refinery].users.any?
  end

end
