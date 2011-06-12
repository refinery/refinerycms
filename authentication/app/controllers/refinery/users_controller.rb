module Refinery
  class UsersController < ::Devise::RegistrationsController

    # Protect these actions behind an admin login
    before_filter :redirect?, :only => [:new, :create]

    layout 'login'

    def new
      @user = User.new
    end

    # This method should only be used to create the first Refinery user.
    def create
      @user = User.new(params[:user])

      if @user.create_first
        flash[:message] = "<h2>#{t('welcome', :scope => 'refinery.users.create', :who => @user.username).gsub(/\.$/, '')}.</h2>".html_safe

        site_name_setting = ::Refinery::Setting.find_or_create_by_name('site_name', :value => "Company Name")
        if site_name_setting.value.to_s =~ /^(|Company\ Name)$/ or Role[:refinery].users.count == 1
          flash[:message] << "<p>#{
            t('setup_website_name_html', :scope => 'refinery.users',
              :link => main_app.edit_refinery_admin_setting_path(site_name_setting, :dialog => true),
              :title => t('edit', :scope => 'refinery.admin.settings'))
            }</p>".html_safe
        end
        sign_in(@user)
        redirect_back_or_default(main_app.refinery_admin_root_path)
      else
        render :action => 'new'
      end
    end

  protected

    def redirect?
      if refinery_user?
        redirect_to main_app.refinery_admin_users_path
      elsif refinery_users_exist?
        redirect_to main_app.new_refinery_user_session_path
      end
    end

    def refinery_users_exist?
      Role[:refinery].users.any?
    end

  end
end
