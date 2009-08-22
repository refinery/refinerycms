# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper_method :home_page?, :local_request?, :just_installed?, :from_dialog?

  protect_from_forgery # See ActionController::RequestForgeryProtection
  
  include Crud # basic create, read, update and delete methods
  include AuthenticatedSystem
  
  before_filter :find_pages_for_menu, :show_welcome_page
  rescue_from ActiveRecord::RecordNotFound, :with => :error_404
  rescue_from ActionController::UnknownAction, :with => :error_404

  def error_404
    @page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])
    render :template => "/pages/show"
  end
  
  def home_page?
    params[:action] == "home" and params[:controller] == "pages"
  end
   
  def local_request?
    request.remote_ip =~ /(::1)|(127.0.0.1)|((192.168).*)/ or ENV["RAILS_ENV"] == "development"
  end
  
  def just_installed?
    User.count == 0
  end
  
  def from_dialog?
    params[:dialog] == "true"
  end

protected

  def show_welcome_page
    if just_installed? and params[:controller] != "users"
      render :template => "/pages/welcome", :layout => "admin" 
    end
  end

  def find_pages_for_menu
		@menu_pages = Page.top_level(include_children=true)
  end
  
end