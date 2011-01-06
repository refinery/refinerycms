class SessionsController < Devise::SessionsController
  layout 'login'

  def create
    super
  rescue BCrypt::Errors::InvalidSalt
    flash[:error] = t('.password_encryption', :scope => 'users.forgot')
    redirect_to new_user_password_path
  end
end
