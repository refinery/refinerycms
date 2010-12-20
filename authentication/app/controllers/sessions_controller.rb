class SessionsController < ApplicationController
  layout 'login'

  before_filter :redirect?, :only => [:new, :create]

  def new
    @session = UserSession.new
  end

  def create
    if (@session = UserSession.create(params[:session])).valid?
      flash.notice = t('sessions.login_successful') if refinery_user?
      redirect_back_or_default(admin_root_url)
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy if logged_in?

    redirect_to(root_url)
  end

protected

  def redirect?
    if refinery_user?
      redirect_to admin_root_url
    elsif logged_in?
      redirect_to root_url
    end
  end

end
