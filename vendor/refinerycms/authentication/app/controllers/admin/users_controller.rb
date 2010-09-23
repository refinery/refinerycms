class Admin::UsersController < Admin::BaseController

  crudify :user, :order => 'login', :title_attribute => 'login'

  # Protect these actions behind an admin login
  before_filter :find_user, :except => [:index, :new, :create]
  before_filter :load_available_plugins_and_roles, :only => [:new, :create, :edit, :update]

  layout 'admin'

  def new
    @user = User.new
    @selected_plugin_names = []
  end

  def create
    @user = User.new(params[:user])
    @selected_plugin_names = params[:user][:plugins] || []
    @user.add_role(:refinery)

    if @user.save
      @user.plugins = @selected_plugin_names
      redirect_to(admin_users_url, :notice => t('refinery.crudify.created', :what => @user.login))
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find params[:id]
    @selected_plugin_names = @user.plugins.collect{|p| p.name}
  end

  def update
    @selected_roles_names = params[:user].delete(:roles)
    @selected_plugin_names = params[:user][:plugins]
    # Prevent the current user from locking themselves out of the User manager
    if current_user.id == @user.id and ( !params[:user][:plugins].include?("refinery_users") || !params[:user][:roles].include?("refinery") )
      flash.now[:error] = t('admin.users.update.cannot_remove_user_plugin_from_current_user')
      render :action => "edit"
    else
      @previously_selected_plugin_names = @user.plugins.collect{|p| p.name}
      @previously_selected_roles = @user.roles
      @user.roles.clear
      @selected_roles_names.each { | rn | @user.add_role( rn ) } if @selected_roles_names
      if @user.update_attributes params[:user]
        redirect_to admin_users_url, :notice => t('refinery.crudify.updated', :what => @user.login)
      else
        @user.plugins = @previously_selected_plugin_names
        @user.roles = @previously_selected_roles
        @user.save
        render :action => 'edit'
      end
    end
  end

protected

  def load_available_plugins_and_roles
    @available_plugins = ::Refinery::Plugins.registered.in_menu.collect{|a| {:name => a.name, :title => a.title} }.sort_by {|a| a[:title]}
    @available_roles = Role.find( :all )
  end

end
