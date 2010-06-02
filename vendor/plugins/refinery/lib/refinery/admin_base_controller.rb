class Refinery::AdminBaseController < ApplicationController

  layout proc { |controller| "admin#{"_dialog" if controller.from_dialog?}" }

  before_filter :redirect_if_old_url, :correct_accept_header, :login_required, :restrict_plugins, :restrict_controller
  after_filter :store_location?, :except => [:new, :create, :edit, :update, :destroy, :update_positions] # for redirect_back_or_default

  helper_method :searching?

  def admin?
    true # we're in the admin base controller, so always true.
  end

  def searching?
    params[:search].present?
  end

protected

  def error_404(exception=nil)
    @page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])
    @page[:body] = @page[:body].gsub(/href=(\'|\")\/(\'|\")/, "href='/admin'").gsub("home page", "Dashboard")
    render :template => "/pages/show", :status => 404
  end

  def restrict_plugins
    Refinery::Plugins.set_active( current_user.authorized_plugins ) if current_user.respond_to? :plugins
  end

  def restrict_controller
    if Refinery::Plugins.active.reject {|plugin|
      params[:controller] !~ Regexp.new(plugin.menu_match) and
      params[:controller] !~ Regexp.new(plugin.menu_match.to_s.gsub('admin\/', 'refinery/'))
    }.empty?
      flash[:error] = "You do not have permission to access this feature."
      logger.warn "'#{current_user.login}' tried to access '#{params[:controller]}' but was rejected."
      redirect_back_or_default(admin_root_url)
    end
  end

  # Override method from application_controller. Not needed in this controller.
  def find_pages_for_menu; end

private
  # This fixes the issue where Internet Explorer browsers are presented with a basic auth dialogue
  # rather than the xhtml one that they *can* accept but don't think they can.
  def correct_accept_header
    if request.user_agent =~ /MSIE (6|7|8)/
      if request.accept == "*/*"
        request.env["HTTP_ACCEPT"] = request.cookies[:http_accept] ||= "application/xml"
      else
        request.cookies[:http_accept] = (request.env["HTTP_ACCEPT"] = (["text/html"] | request.accept.split(', ')).join(', '))
      end
    end
  end

  # Just a simple redirect for old urls.
  def redirect_if_old_url
    redirect_to request.path.gsub('admin', 'refinery') if request.path =~ /^(|\/)admin/
  end

  # Check whether it makes sense to return the user to the last page they
  # were at instead of the default e.g. admin_pages_url
  # right now we just want to snap back to index actions and definitely not to dialogues.
  def store_location?
    store_location unless action_name !~ /index/ or request.xhr? or from_dialog?
  end

end
