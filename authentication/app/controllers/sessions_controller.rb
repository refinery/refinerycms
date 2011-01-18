class SessionsController < Devise::SessionsController
  layout 'login'

  before_filter :clear_unauthenticated_flash, :only => [:new]

  def create
    super
  rescue BCrypt::Errors::InvalidSalt
    flash[:error] = t('password_encryption', :scope => 'users.forgot')
    redirect_to new_user_password_path
  end

protected
  # We don't like this alert.
  def clear_unauthenticated_flash
    if flash.keys.include?(:alert) and flash.values.any?{|v|
      ['unauthenticated', t('unauthenticated', :scope => 'devise.failure')].include?(v)
    }
      flash.delete(:alert)
    end
  end

end
