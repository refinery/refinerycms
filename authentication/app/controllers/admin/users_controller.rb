module Admin
  class UsersController < Admin::BaseController

    crudify :user,
            :order => 'username ASC',
            :title_attribute => 'username',
            :xhr_paging => true

    before_filter :load_available_plugins_and_roles, :only => [:new, :create, :edit, :update]

    def new
      @user = User.new
      @selected_plugin_names = []
    end

    def create
      @user = User.new(params[:user])
      @selected_plugin_names = params[:user][:plugins] || []
      @selected_role_names = params[:user][:roles] || []

      if @user.save
        @user.plugins = @selected_plugin_names
        # if the user is a superuser and can assign roles according to this site's
        # settings then the roles are set with the POST data.
        unless current_user.has_role?(:superuser) and RefinerySetting.find_or_set(:superuser_can_assign_roles, false)
          @user.add_role(:refinery)
        else
          @user.roles = @selected_role_names.collect{|r| Role[r.downcase.to_sym]}
        end

        redirect_to(admin_users_url, :notice => t('created', :what => @user.username, :scope => 'refinery.crudify'))
      else
        render :action => 'new'
      end
    end

    def edit
      @user = User.find params[:id]
      @selected_plugin_names = @user.plugins.collect{|p| p.name}
    end

    def update
      # Store what the user selected.
      @selected_role_names = params[:user].delete(:roles) || []
      unless current_user.has_role?(:superuser) and RefinerySetting.find_or_set(:superuser_can_assign_roles, false)
        @selected_role_names = @user.roles.collect{|r| r.title}
      end
      @selected_plugin_names = params[:user][:plugins]

      # Prevent the current user from locking themselves out of the User manager
      if current_user.id == @user.id and (params[:user][:plugins].exclude?("refinery_users") || @selected_role_names.map(&:downcase).exclude?("refinery"))
        flash.now[:error] = t('cannot_remove_user_plugin_from_current_user', :scope => 'admin.users.update')
        render :action => "edit"
      else
        # Store the current plugins and roles for this user.
        @previously_selected_plugin_names = @user.plugins.collect{|p| p.name}
        @previously_selected_roles = @user.roles
        @user.roles = @selected_role_names.collect{|r| Role[r.downcase.to_sym]}
        if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end

        if @user.update_attributes(params[:user])
          redirect_to admin_users_url, :notice => t('updated', :what => @user.username, :scope => 'refinery.crudify')
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
      @available_plugins = ::Refinery::Plugins.registered.in_menu.collect{|a|
        {:name => a.name, :title => a.title}
      }.sort_by {|a| a[:title]}

      @available_roles = Role.all
    end

  end
end
