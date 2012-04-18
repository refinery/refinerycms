module Refinery
  module Admin
    class UsersController < Refinery::AdminController

      crudify :'refinery/user',
              :order => 'username ASC',
              :title_attribute => 'username',
              :xhr_paging => true

      before_filter :load_available_plugins_and_roles, :only => [:new, :create, :edit, :update]

      def new
        @user = Refinery::User.new
        @selected_plugin_names = []
      end

      def create
        @user = Refinery::User.new(params[:user].except(:roles))
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
        redirect_unless_user_editable!

        @selected_plugin_names = @user.plugins.collect(&:name)
      end

      def update
        redirect_unless_user_editable!

        # Store what the user selected.
        @selected_role_names = params[:user].delete(:roles) || []
        unless current_refinery_user.has_role?(:superuser) and Refinery::Authentication.superuser_can_assign_roles
          @selected_role_names = @user.roles.collect(&:title)
        end
        @selected_plugins = params[:user][:plugins]

        # Prevent the current user from locking themselves out of the User manager or backend
        if current_refinery_user.id == @user.id && # If editing self
           ((@selected_plugins.present? && # If we're submitting plugins
             @selected_plugins.exclude?("refinery_users")) || # And we're removing user plugin access
             @selected_role_names.map(&:downcase).exclude?("refinery")) # Or we're removing the refinery role

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

      def find_user_with_slug
        begin
          find_user_without_slug
        rescue ActiveRecord::RecordNotFound
          @user = Refinery::User.all.detect{|u| u.to_param == params[:id]}
        end
      end
      alias_method_chain :find_user, :slug

      def load_available_plugins_and_roles
        @available_plugins = Refinery::Plugins.registered.in_menu.collect { |a|
          { :name => a.name, :title => a.title }
        }.sort_by { |a| a[:title] }

        @available_roles = Refinery::Role.all
      end

      def redirect_unless_user_editable!
        unless current_refinery_user.can_edit?(@user)
          redirect_to(refinery.admin_users_path) and return
        end
      end
    end
  end
end
