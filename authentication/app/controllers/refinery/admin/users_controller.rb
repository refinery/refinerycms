module Refinery
  module Admin
    class UsersController < Refinery::AdminController

      crudify :'refinery/user',
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
          unless current_refinery_user.has_role?(:superuser) and Refinery::Authentication.superuser_can_assign_roles
            @user.add_role(:refinery)
          else
            @user.roles = @selected_role_names.collect { |r| Refinery::Role[r.downcase.to_sym] }
          end

          redirect_to refinery.admin_users_path,
                      :notice => t('created', :what => @user.username, :scope => 'refinery.crudify')
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
        unless current_refinery_user.has_role?(:superuser) and Refinery::Authentication.superuser_can_assign_roles
          @selected_role_names = @user.roles.collect(&:title)
        end
        @selected_plugin_names = params[:user][:plugins]

        # Prevent the current user from locking themselves out of the User manager
        if current_refinery_user.id == @user.id and (params[:user][:plugins].exclude?("refinery_users") || @selected_role_names.map(&:downcase).exclude?("refinery"))
          flash.now[:error] = t('cannot_remove_user_plugin_from_current_user', :scope => 'refinery.admin.users.update')
          render :edit
        else
          # Store the current plugins and roles for this user.
          @previously_selected_plugin_names = @user.plugins.collect(&:name)
          @previously_selected_roles = @user.roles
          @user.roles = @selected_role_names.collect { |r| Refinery::Role[r.downcase.to_sym] }
          if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
            params[:user].except!(:password, :password_confirmation)
          end

          if @user.update_attributes(params[:user])
            redirect_to refinery.admin_users_path,
                        :notice => t('updated', :what => @user.username, :scope => 'refinery.crudify')
          else
            @user.plugins = @previously_selected_plugin_names
            @user.roles = @previously_selected_roles
            @user.save
            render :edit
          end
        end
      end

    protected

    def load_available_plugins_and_roles
      @available_plugins = Refinery::Plugins.registered.in_menu.collect { |a|
        { :name => a.name, :title => a.title }
      }.sort_by { |a| a[:title] }

      @available_roles = Refinery::Role.all
    end

    end
  end
end
