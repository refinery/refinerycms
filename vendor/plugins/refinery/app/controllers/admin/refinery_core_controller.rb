class Admin::RefineryCoreController < Admin::BaseController

	def update_plugin_positions
	  current_user.update_attribute(:plugins, params[:menu].join(","))
	  render :nothing => true
  end
  
end