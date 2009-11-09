class Refinery::AdminBaseController < ApplicationController
  
  layout proc { |controller| "admin#{"_dialog" if controller.from_dialog?}" }
  
  before_filter :login_required, :restrict_plugins, :restrict_controller

  helper_method :searching?

	def admin?
		true # we're in the admin base controller, so always true.
	end
	
	def searching?
    not params[:search].blank?
  end

protected

  def error_404
    @page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])
    @page[:body] = @page[:body].gsub(/href=(\'|\")\/(\'|\")/, "href='/admin'").gsub("home page", "Dashboard")
    render :template => "/pages/show", :status => 404
  end
  
  def restrict_plugins
    Refinery::Plugins.set_active( current_user.authorized_plugins ) if current_user.respond_to? :plugins
  end

	def restrict_controller
    if Refinery::Plugins.active.reject {|plugin| params[:controller] !~ Regexp.new(plugin.menu_match) }.empty?
			flash[:error] = "You do not have permission to access the #{params[:controller]} controller on this plugin."
			logger.warn "'#{current_user.login}' tried to access '#{params[:controller]}'"
		end
	end
  
end