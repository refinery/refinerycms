class Admin::BaseController < ApplicationController
  
  layout :pick_refinery_admin_layout
  
  before_filter :login_required, :restrict_plugins, :restrict_controller

protected

  def error_404
    @page = Page.find_by_menu_match("^/404$")
    @page[:body] = @page[:body].gsub(/href=(\'|\")\/(\'|\")/, "href='/admin'").gsub("home page", "Dashboard")
    render :template => "/pages/show"
  end
  
  def restrict_plugins
		if current_user.respond_to?('plugins')
	   	user_plugins = ((not current_user.plugins.blank?) ? current_user.plugins.split(',') : []) | ["Dashboard", "Refinery", "Dialogs"]

      # Kick out plugins if they're not in the user's plugin list and then sort them by how the user likes to see them.
	   	$plugins = $plugins.reject { |plugin| !user_plugins.include?(plugin.title) }.sort do |a,b|
	   		user_plugins.index(a.send('title')) <=> user_plugins.index(b.send('title'))
	   	end
		end
  end

	def restrict_controller
    if params[:controller] != "admin/base" and $plugins.reject {|plugin| params[:controller] !~ Regexp.new(plugin.menu_match) }.empty?
			flash[:error] = "You do not have permission to access the #{params[:controller]} controller on this plugin."
			logger.warn("'#{current_user.login}' tried to access '#{params[:controller]}'")
			redirect_to admin_root_url
		end
	end
	
	def pick_refinery_admin_layout
	  params[:dialog].to_s.downcase != "true" ? "admin" : "admin_dialog"
  end
  
end