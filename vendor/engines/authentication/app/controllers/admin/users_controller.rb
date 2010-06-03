class Admin::UsersController < Admin::BaseController

  crudify :user, :order => 'login', :title_attribute => 'login'

  # Protect these actions behind an admin login
  before_filter :find_user, :except => [:index, :new, :create]
  before_filter :load_available_plugins, :only => [:new, :create, :edit, :update]

  layout 'admin'

  def new
    @user = User.new
    @selected_plugin_titles = []
  end

  def create
    @user = User.new(params[:user])
    @selected_plugin_titles = params[:user][:plugins] || []

    if @user.save
      @user.plugins = @selected_plugin_titles
      redirect_to :action => 'index', :notice => "'#{@user.login}' was successfully created."
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find params[:id]
    @selected_plugin_titles = @user.plugins.collect{|p| p.title}
  end

  def update
    @selected_plugin_titles = params[:user][:plugins]
    # Prevent the current user from locking themselves out of the User manager
    if current_user.id == @user.id and !params[:user][:plugins].include?("Users")
      flash.now[:error] = "You cannot remove the 'Users' plugin from the currently logged in account."
      render :action => "edit"
    else
      @previously_selected_plugins_titles = @user.plugins.collect{|p| p.title}
      if @user.update_attributes params[:user]
        redirect_to admin_users_url, :notice => "'#{@user.login}' was successfully updated."
      else
        @user.plugins = @previously_selected_plugins_titles
        @user.save
        render :action => 'edit'
      end
    end
  end

protected

  def can_create_public_user
    User.count == 0
  end

  def load_available_plugins
    @available_plugins = Refinery::Plugins.registered.in_menu.titles.sort
  end

end
