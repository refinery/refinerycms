class Admin::UsersController < Admin::BaseController
  
  crudify :user, :order => 'login', :title_attribute => 'login', :conditions => "state = 'active'"
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :except => [:new, :create]
  before_filter :load_available_plugins, :only => [:new, :create, :edit, :update]
  
  filter_parameter_logging 'password', 'password_confirmation'
  
  layout 'admin'
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.plugins = update_plugins_from_params
    # render :inline => "<%= debug params; debug @user.plugins; %>" and return
    if @user.save
      @user.activate!
      flash[:notice] = "'#{@user.login}' was successfully created."
      redirect_to :action => 'index'
    else 
      render :action => 'new'
    end
  end
  
  def edit
    
  end
  
  def new
    @user = User.new
    @user.plugins = @available_plugins.join(',')
  end
  
  def update
    @user.attributes = params[:user]
    @user.plugins = update_plugins_from_params
    # render :inline => "<%= debug params; debug @user.plugins; %>" and return
    
    # Prevent the current user from locking themselves out of the User manager
    if current_user.id == @user.id && !@user.plugins.include?('Users')
      flash.now[:error] = "You cannot remove the 'Users' plugin from the currently logged in account."
      render :action => "edit"
    else
      if @user.save
        flash[:notice] = "'#{@user.login}' was successfully updated."
        redirect_to admin_users_url
      else
        render :action => 'edit'
      end
    end
  end
  
  def suspend
    @user.suspend! 
    redirect_to admin_users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to admin_users_path
  end

  def destroy
    @user.delete!
    flash[:notice] = "'#{@user.login}' was successfully deleted."
    redirect_to admin_users_path
  end

  def purge
    @user.destroy
    redirect_to admin_users_path
  end

protected

  def find_user
    @user = User.find(params[:id])
  end
  
  def can_create_public_user
    User.count == 0
  end
  
  # This converts the check box array into a storable plugin list 
  # maintaining the users current sort order
  def update_plugins_from_params
    return @user.plugins unless params[:plugins]
    updated = @user.plugins.clone
    # Add newly accessible
    params[:plugins].each { |p| updated << p unless updated.include?(p) }
    # Remove protected
    updated.delete_if{ |p| !params[:plugins].include?(p) }
    updated
  end
  
  def load_available_plugins
    @available_plugins = Refinery::Plugin.registered.reject{ |p| p.hide_from_menu }.collect { |p| p.title }.sort
  end

end