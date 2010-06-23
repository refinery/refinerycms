class Admin::InquirySettingsController < Admin::BaseController

  crudify :inquiry_setting, :title_attribute => "name", :order => 'name ASC', :redirect_to_url => "admin_inquiries_url"

  before_filter :set_url_override?, :only => [:edit]

protected
  def set_url_override?
    @url_override = admin_inquiry_setting_url(@inquiry_setting, :dialog => from_dialog?)
  end

end
