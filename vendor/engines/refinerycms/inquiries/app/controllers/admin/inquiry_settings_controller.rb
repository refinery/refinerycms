class Admin::InquirySettingsController < Admin::BaseController

  crudify :inquiry_setting, :title_attribute => "name", :order => 'name ASC', :redirect_to_url => "admin_inquiries_url"

  before_filter :redirect_back_to_inquiries?, :only => [:index]
  before_filter :set_url_override?, :only => [:edit]
  after_filter :save_subject_for_confirmation?, :only => [:create, :update]

protected
  def save_subject_for_confirmation?
    InquirySetting.confirmation_subject = params[:subject] if params.keys.include?('subject')
  end

  def redirect_back_to_inquiries?
    redirect_to admin_inquiries_url
  end

  def set_url_override?
    @url_override = admin_inquiry_setting_url(@inquiry_setting, :dialog => from_dialog?)
  end

end
