class Admin::RefineryCoreController < Admin::BaseController

  def update_plugin_positions
    params[:menu].each_with_index do |plugin_name, index|
      current_user.plugins.find_by_name(plugin_name).update_attribute(:position, index)
    end
    render :nothing => true
  end

  def render_flash_messages
    render :partial => "/shared/message"
  end

end
