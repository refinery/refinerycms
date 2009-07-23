class Admin::DialogsController < Admin::BaseController
  
  layout 'admin_dialog'
  
  def show
    unless (@dialog_type = params[:id]).blank?
      @submit_button_text = "Insert"
      
      if @dialog_type.downcase.split("&")[0] == "image"
        @iframe_src = insert_admin_images_url(params.merge({:dialog => true}))
      elsif @dialog_type.downcase.split("&")[0] == "link"
        @iframe_src = link_to_admin_pages_dialogs_url(params)
      end
      
      render :layout => false#"admin_dialog"
      
    else
      render :nothing => true
    end
  end
  
  
  
#  /admin/image_dialogs/insert
#  /admin/page_dialogs/link_to
  
#  /admin/dialogs/pages/link_to
#  /admin/dialogs/images/insert
  
end