class Admin::RefineryCoreController < Admin::BaseController

	def update_plugin_positions
	  current_user.update_attribute(:plugins, params[:menu])
	  render :nothing => true
  end
  
  def render_flash_messages
    render :partial => "/shared/message"
  end

end