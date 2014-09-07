module Refinery
  class UsersController < Devise::RegistrationsController

    # Protect these actions behind an admin login
    before_filter :redirect?, :only => [:new, :create]

    helper Refinery::Core::Engine.helpers
    layout 'refinery/layouts/login'

    def new
      @user = User.new
    end

    # This method should only be used to create the first Refinery user.
    def create
      @user = User.new(user_params)

      if @user.create_first
        flash[:message] = t('welcome', scope: 'refinery.users.create', who: @user)

        sign_in(@user)
        redirect_back_or_default(refinery.admin_root_path)
      else
        render :new
      end
    end

    protected

    def redirect?
      if refinery_user?
        redirect_to refinery.admin_users_path
      elsif refinery_users_exist?
        redirect_to refinery.login_path
      end
    end

    def refinery_users_exist?
      Refinery::Role[:refinery].users.any?
    end

    def user_params
      params.require(:user).permit(
        :email, :password, :password_confirmation, :remember_me, :username,
        :plugins, :login, :full_name
      )
    end

  end
end
