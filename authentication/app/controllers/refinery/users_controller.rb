module Refinery
  class UsersController < Devise::RegistrationsController

    skip_before_filter :find_pages_for_menu

    # Protect these actions behind an admin login
    before_filter :redirect?, :only => [:new, :create]

    layout 'refinery/layouts/login'

    def new
      @user = User.new
    end

    # This method should only be used to create the first Refinery user.
    def create
      @user = User.new(params[:user])

      if @user.create_first
        flash[:message] = "<h2>#{t('welcome', :scope => 'refinery.users.create', :who => @user.username).gsub(/\.$/, '')}.</h2>".html_safe

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
        redirect_to refinery.new_refinery_user_session_path
      end
    end

    def refinery_users_exist?
      Refinery::Role[:refinery].users.any?
    end

  end
end
