module Refinery
  class SessionsController < Devise::SessionsController
    helper Refinery::Core::Engine.helpers
    layout 'refinery/layouts/login'

    before_action :clear_unauthenticated_flash, :only => [:new]

    def create
      super
    rescue ::BCrypt::Errors::InvalidSalt, ::BCrypt::Errors::InvalidHash
      flash[:error] = t('password_encryption', :scope => 'refinery.users.forgot')
      redirect_to refinery.new_refinery_user_password_path
    end

  protected

    # We don't like this alert.
    def clear_unauthenticated_flash

      if flash[:alert].present? && (flash[:alert] == t('unauthenticated', :scope => 'devise.failure'))
        flash.delete(:alert)
      end
    end

  end
end
