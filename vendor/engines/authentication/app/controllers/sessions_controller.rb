class SessionsController < ApplicationController

  layout 'admin'
  filter_parameter_logging 'password', 'password_confirmation'

  def create
    self.current_user = User.authenticate(params[:session][:login], params[:session][:password])

    if logged_in?
      if params[:session][:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = {:value => self.current_user.remember_token ,
                                :expires => self.current_user.remember_token_expires_at}
      end

      redirect_back_or_default(admin_root_url)
      flash[:notice] = "Logged in successfully"
    else
      flash.now[:error] = "Sorry, your password or username was incorrect."
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(new_session_url)
  end

protected

  def take_down_for_maintenance?;end

end
