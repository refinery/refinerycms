class SessionsController < ApplicationController
  layout 'admin'
  filter_parameter_logging 'password', 'password_confirmation'
  before_filter :redirect?, :only => [:new, :create]
  before_filter :redirect_to_new, :only => [:index, :show]

  def new
    @session = UserSession.new
  end

  def create
    if (@session = UserSession.create(params[:session])).valid?
      flash[:notice] = t('sessions.login_successful')
      redirect_back_or_default(admin_root_url)
    else
      render :action => 'new'
    end
  end

  def destroy
    current_user_session.destroy if logged_in?
    flash[:notice] = t('sessions.logged_out')
    redirect_back_or_default(root_url)

    redirect_to(root_url)
  end

protected

  def redirect?
    redirect_to admin_root_url if logged_in?
  end

  def redirect_to_new
    redirect_to :action => "new"
  end

end
