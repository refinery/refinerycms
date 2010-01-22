class Admin::InquiriesController < Admin::BaseController

  crudify :inquiry, :title_attribute => "name", :order => "created_at DESC"

  before_filter :find_inquiry, :only => [:show, :toggle_status, :destroy]
  before_filter :find_all_inquiries, :only => [:index]

  def toggle_status
    @inquiry.toggle!(:open)

    flash[:notice] = I18n.translate(@inquiry.open? ? 'reopened' : 'closed', :scope => 'admin.inquiries.toggle_status', :inquiry => @inquiry.name)

    redirect_to :action => 'index'
  end

  protected

  def find_all_inquiries
    @open_inquiries = Inquiry.opened
    @closed_inquiries = Inquiry.closed
    @inquiries = @open_inquiries
  end

end
