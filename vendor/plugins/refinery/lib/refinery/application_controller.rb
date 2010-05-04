class Refinery::ApplicationController < ActionController::Base

  helper_method :home_page?, :local_request?, :just_installed?, :from_dialog?, :admin?
  protect_from_forgery # See ActionController::RequestForgeryProtection

  include Crud # basic create, read, update and delete methods
  include AuthenticatedSystem

  before_filter :take_down_for_maintenance?, :find_pages_for_menu, :show_welcome_page?

  rescue_from ActiveRecord::RecordNotFound, ActionController::UnknownAction, ActionView::MissingTemplate, :with => :error_404

  def admin?
    controller_name =~ %r{^admin/}
  end

  def error_404(exception=nil)
    if (@page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])).present?
      if exception.present? and exception.is_a?(ActionView::MissingTemplate) and params[:format] != "html"
        # Attempt to respond to all requests with the default format's 404 page
        # unless a format wasn't specified. This requires finding menu pages and re-attaching any themes
        # which for some unknown reason don't happen, most likely due to the format being passed in.
        response.template.template_format = :html
        response.headers["Content-Type"] = Mime::Type.lookup_by_extension('html').to_s
        find_pages_for_menu if @menu_pages.nil? or @menu_pages.empty?
        attach_theme_to_refinery if self.respond_to?(:attach_theme_to_refinery) # may not be using theme support
        present(@page)
      end

      # render the application's custom 404 page with layout and meta.
      render :template => "/pages/show", :status => 404, :format => 'html'
    else
      # fallback to the default 404.html page.
      render :file => Rails.root.join("public", "404.html").cleanpath.to_s, :layout => false, :status => 404
    end
  end

  def from_dialog?
    params[:dialog] == "true" or params[:modal] == "true"
  end

  def home_page?
    action_name == "home" and controller_name == "pages"
  end

  def just_installed?
    !User.exists?
  end

  def local_request?
    ENV["RAILS_ENV"] == "development" or request.remote_ip =~ /(::1)|(127.0.0.1)|((192.168).*)/
  end

  def wymiframe
    render :template => "/wymiframe", :layout => false
  end

protected

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

  def show_welcome_page?
    render :template => "/welcome", :layout => "admin" if just_installed? and controller_name != "users"
  end
  # todo: make this break in the next major version rather than aliasing.
  alias_method :show_welcome_page, :show_welcome_page?

  def take_down_for_maintenance?
    if RefinerySetting.find_or_set(:down_for_maintenance, false)
      if (@page = Page.find_by_menu_match("^/maintenance$", :include => [:parts, :slugs])).present?
        find_pages_for_menu
        render :template => "/pages/show", :status => 503
      else
        render :text => "Our website is currently down for maintenance. Please try back soon."
      end
    end
  end

end
