class PasswordsController < ::Devise::PasswordsController
  layout 'login'

  # Rather than overriding devise, it seems better to just apply the notice here.
  after_filter :give_notice, :only => [:update]
  def give_notice
    unless %w(notice error alert).include?(flash.keys.map(&:to_s)) or @user.errors.any?
      flash[:notice] = t('successful', :scope => 'users.reset', :email => @user.email)
    end
  end
  protected :give_notice

  # GET /registrations/password/edit?reset_password_token=abcdef
  def edit
    if params[:reset_password_token] and (@user = User.where(:reset_password_token => params[:reset_password_token]).first).present?
      render_with_scope :edit
    else
      redirect_to(new_user_password_url, :flash => ({
        :error => t('code_invalid', :scope => 'users.reset')
      }))
    end
  end

  # POST /registrations/password
  def create
    if params[:user].present? and (email = params[:user][:email]).present? and
       (user = User.where(:email => email).first).present?

      # Call devise reset function.
      user.send(:generate_reset_password_token!)
      UserMailer.reset_notification(user, request).deliver
      redirect_to new_user_session_path, :notice => t('email_reset_sent', :scope => 'users.forgot') and return
    else
      @user = User.new(params[:user])
      flash.now[:error] = if (email = params[:user][:email]).blank?
        t('blank_email', :scope => 'users.forgot')
      else
        t('email_not_associated_with_account_html', :email => ERB::Util.html_escape(email), :scope => 'users.forgot').html_safe
      end
      render_with_scope :new
    end
  end
end
