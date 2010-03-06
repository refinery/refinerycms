class Refinery::AdminBaseController < ApplicationController

  layout proc { |controller| "admin#{"_dialog" if controller.from_dialog?}" }

  before_filter :correct_accept_header, :login_required, :restrict_plugins, :restrict_controller

  helper_method :searching?

  def admin?
    true # we're in the admin base controller, so always true.
  end

  def searching?
    params[:search].present?
  end

protected

  # never take the backend down for maintenance.
  def take_down_for_maintenance?;end

  def error_404
    @page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])
    @page[:body] = @page[:body].gsub(/href=(\'|\")\/(\'|\")/, "href='/admin'").gsub("home page", "Dashboard")
    render :template => "/pages/show", :status => 404
  end

  def restrict_plugins
    puts Refinery::Plugins.active.inspect
    Refinery::Plugins.set_active( current_user.authorized_plugins ) if current_user.respond_to? :plugins
  end

  def restrict_controller
    if Refinery::Plugins.active.reject {|plugin| params[:controller] !~ Regexp.new(plugin.menu_match) }.empty?
      flash[:error] = "You do not have permission to access this feature."
      logger.warn "'#{current_user.login}' tried to access '#{params[:controller]}' but was rejected."
      # FIXME: causing recursive redirect
      # redirect_back_or_default(admin_root_url)
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

end
