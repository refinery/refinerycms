class Admin::DialogsController < Admin::BaseController

  layout 'admin_dialog'

  def show
    unless (@dialog_type = params[:id]).blank?
      @submit_button_text = "Insert"

      url_params = params.reject {|key, value| key =~ /(action)|(controller)/}

      if @dialog_type.downcase.split("&")[0] == "image"
        @iframe_src = insert_admin_images_url(:dialog => true)
      elsif @dialog_type.downcase.split("&")[0] == "link"
        @iframe_src = link_to_admin_pages_dialogs_url(url_params)
      end

      render :layout => false#"admin_dialog"

    else
      render :nothing => true
    end
  end

end
