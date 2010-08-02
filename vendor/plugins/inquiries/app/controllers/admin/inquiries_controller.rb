class Admin::InquiriesController < Admin::BaseController

  crudify :inquiry, :title_attribute => "name", :order => "created_at DESC"

  before_filter :get_spam_count, :only => [:index, :spam]

  def index
    if searching?
      @inquiries = Inquiry.ham.find_with_index params[:search]
    end

    @grouped_inquiries = group_by_date(Inquiry.ham)
  end

  def spam
    if searching?
      @inquiries = Inquiry.spam.find_with_index params[:search]
    end

    @grouped_inquiries = group_by_date(Inquiry.spam)
  end

  def toggle_spam
    find_inquiry
    @inquiry.toggle!(:spam)

    redirect_to :back
  end

protected

  def get_spam_count
    @spam_count = Inquiry.count(:conditions => {:spam => true})
  end

end
