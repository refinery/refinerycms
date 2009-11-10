class InquiriesController < ApplicationController

  before_filter :find_page, :only => [:create, :new]

  def thank_you
    @page = Page.find_by_menu_match("^/inquiries/thank_you$", :include => [:parts, :slugs])
    respond_to do |wants|
      wants.html
    end
  end

  def new
    @inquiry = Inquiry.new
    respond_to do |wants|
      wants.html
    end
  end

  def create
    @inquiry = Inquiry.new(params[:inquiry])

    if @inquiry.save
      begin
        InquiryMailer.deliver_notification(@inquiry, request)
      rescue
        logger.warn "There was an error delivering an inquiry notification.\n#{$!}\n"
      end

      begin
        InquiryMailer.deliver_confirmation(@inquiry, request)
      rescue
        logger.warn "There was an error delivering an inquiry confirmation:\n#{$!}\n"
      end

      redirect_to thank_you_inquiries_url
    else
      render :action => 'new'
    end
  end

protected

  def find_page
    @page = Page.find_by_link_url('/inquiries/new', :include => [:parts, :slugs])
  end

end