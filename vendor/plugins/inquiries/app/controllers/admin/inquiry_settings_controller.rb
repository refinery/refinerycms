class Admin::InquirySettingsController < Admin::BaseController

  crudify :inquiry_setting, :title_attribute => "name", :order => 'name ASC'

  def update
    if @inquiry_setting.update_attributes(params[:inquiry_setting])
      flash[:notice] = I18n.translate('updated', :scope => 'admin.inquiry_settings.update', :setting => @inquiry_setting.name)
      redirect_to params[:return_to] || admin_inquiries_url
    else
      render :action => 'edit'
    end
  end

end
