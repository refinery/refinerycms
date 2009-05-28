class UsersController < ApplicationController
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  
  filter_parameter_logging 'password', 'password_confirmation'
  
  layout 'admin'

  def new
    render :text => "User signup is disabled", :layout => true unless RefinerySetting[:signup_enabled] ||= false
  end
  
  def create
    unless RefinerySetting[:signup_enabled] ||= false
      render :text => "User signup is disabled", :layout => true 
    else
      begin
          cookies.delete :auth_token
          # protects against session fixation attacks, wreaks havoc with 
          # request forgery protection.
          # uncomment at your own risk
          # reset_session
          @user = User.new(params[:user])

          @user.register! if @user.valid?
          if @user.errors.empty?
            self.current_user = @user
            current_user.activate!
            redirect_back_or_default(admin_root_url)
            
            flash[:notice] = "Welcome to Refinery, #{current_user.login}."
            if User.count == 1 or RefinerySetting[:site_name] == "Company Name"
              refinery_setting = RefinerySetting.find_by_name("site_name")
              flash[:notice] << " First let's give the site a name. <a href='#{edit_admin_refinery_setting_url(refinery_setting)}'>Go here</a> to edit your website's name"
            end
          else
            render :action => 'new'
          end
      end
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
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

  def find_user
    @user = User.find(params[:id])
  end

end