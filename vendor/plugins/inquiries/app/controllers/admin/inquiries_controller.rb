class Admin::InquiriesController < Admin::BaseController

  crudify :inquiry, :title_attribute => "name", :order => "created_at DESC"
  
  before_filter :get_spam_count, :only => [:index, :spam]
  
  def index
    @grouped_inquiries = group_by_date(Inquiry.ham)
  end

  def spam
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
  
  # maybe move this up to the refinery level application controller as other plugins use a similar method
  def group_by_date(records)
    new_records = []

    records.each do |record|
      key = record.created_at.strftime("%Y-%m-%d")
      record_group = new_records.collect{|records| records.last if records.first == key }.flatten.compact << record
      (new_records.delete_if {|i| i.first == key}) << [key, record_group]
    end
    
    new_records
  end

end
