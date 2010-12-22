class PasswordsController < Devise::PasswordsController
  layout 'login'

  # GET /registrations/password/edit?reset_password_token=abcdef
  def edit
    if params[:reset_password_token] and (@user = User.find_by_reset_password_token(params[:reset_password_token])).present?
      render_with_scope :edit
    else
      redirect_to(new_user_password_url, :flash => {:error => t('users.reset.code_invalid')})
    end
  end

  # POST /registrations/password
  def create
    if params[:user].present? and (email = params[:user][:email]).present? and
       (user = User.find_by_email(email)).present?

      UserMailer.reset_notification(user, request).deliver
      redirect_to new_user_session_path, :notice => t('users.forgot.email_reset_sent') and return
    else
      @user = User.new(params[:user])
      flash.now[:error] = if (email = params[:user][:email]).blank?
        t('users.forgot.blank_email')
      else
        t('users.forgot.email_not_associated_with_account_html', :email => email).html_safe
      end
      render :action => 'edit'
    end
  end
end