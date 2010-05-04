class Admin::InquiriesController < Admin::BaseController

  crudify :inquiry, :title_attribute => "name", :order => "created_at DESC"

  def index
    @grouped_inquiries = []

    Inquiry.all.each do |inquiry|
      key = inquiry.created_at.strftime("%Y-%m-%d")
      inquiry_group = @grouped_inquiries.collect{|inquiries| inquiries.last if inquiries.first == key }.flatten.compact << inquiry
      (@grouped_inquiries.delete_if {|i| i.first == key}) << [key, inquiry_group]
    end
  end

  def show
    find_inquiry
  end

end
