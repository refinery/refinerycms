class Refinery::ApplicationController < ActionController::Base

  helper_method :home_page?, :local_request?, :just_installed?, :from_dialog?, :admin?

  protect_from_forgery # See ActionController::RequestForgeryProtection

  include Crud # basic create, read, update and delete methods
  include AuthenticatedSystem

  before_filter :take_down_for_maintenance?, :setup_theme, :find_pages_for_menu, :show_welcome_page

  rescue_from ActiveRecord::RecordNotFound, :with => :error_404
  rescue_from ActionController::UnknownAction, :with => :error_404

  def error_404
    @page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])
    render :template => "/pages/show", :status => 404
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

	def setup_theme
	  self.view_paths = ::ActionController::Base.view_paths.dup.unshift(Rails.root.join("themes", RefinerySetting[:theme], "views").to_s)
	end

  def take_down_for_maintenance?
    if RefinerySetting.find_or_set(:down_for_maintenance, false)
      if (@page = Page.find_by_menu_match("^/maintenance$", :include => [:parts, :slugs])).present?
        render :template => "/pages/show", :status => 503
      else
        render :text => "Our website is currently down for maintenance. Please try back soon."
      end
    end
  end

  def show_welcome_page
    render :template => "/welcome", :layout => "admin" if just_installed? and params[:controller] != "users"
  end

  # get all the pages to be displayed in the site menu.
  def find_pages_for_menu
    @menu_pages = Page.top_level(include_children=true)
  end

  # use a different model for the meta information.
  def present(model)
    presenter = Object.const_get("#{model.class}Presenter") rescue Refinery::BasePresenter
    @meta = presenter.new(model)
  end

  # this hooks into the Rails render method.
  def render(action = nil, options = {}, &blk)
    present(@page) unless admin? or @meta.present?
    super
  end

end