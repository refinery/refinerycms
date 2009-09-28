class Refinery::ApplicationController < ActionController::Base
	
	  helper_method :home_page?, :local_request?, :just_installed?, :from_dialog?, :admin?

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
	    params[:dialog] == "true" or params[:modal] == "true"
	  end

		def admin?
			params[:controller] =~ /admin\/(.*)/
		end

		def wymiframe
			render :template => "/wymiframe", :layout => false
		end

	protected

	  def show_welcome_page
			render :template => "/welcome", :layout => "admin" if just_installed? and params[:controller] != "users"
	  end

	  def find_pages_for_menu
			@menu_pages = Page.top_level(include_children=true) unless admin?
	  end
	
end