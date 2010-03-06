class Admin::InquirySettingsController < Admin::BaseController

  crudify :inquiry_setting, :title_attribute => "name", :order => 'name ASC'

  def update
    @inquiry_setting.update_attributes(params[:inquiry_setting])

    if @inquiry_setting.valid?
      flash[:notice] = "'#{@inquiry_setting.name}' was successfully updated."
      redirect_to admin_inquiries_url
    else
      render :action => 'edit'
    end
  end

end
