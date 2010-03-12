class SessionsController < ApplicationController
  layout 'admin'

  def create
    if (@session = UserSession.create(params[:session]))
      redirect_back_or_default(admin_root_url)
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy if logged_in?
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(new_session_url)
  end

protected

  def take_down_for_maintenance?;end

end
