class Admin::DialogsController < Admin::BaseController

  layout 'admin_dialog'

  def show
    @dialog_type = params[:id].try(:downcase)
    
    if @dialog_type
      @submit_button_text = "Insert"

      url_params = params.reject {|key, value| key =~ /(action)|(controller)/}

      if @dialog_type == 'image'
        @iframe_src = insert_admin_images_url(:dialog => true)
      elsif @dialog_type == 'link'
        @iframe_src = link_to_admin_pages_dialogs_url(url_params)
      end

      render :layout => false #"admin_dialog"

    else
      render :nothing => true
    end
  end

end
