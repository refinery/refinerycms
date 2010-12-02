class <%= class_name.pluralize %>Controller < ApplicationController

  before_filter :find_page, :only => [:create, :new]

  def index
    redirect_to :action => "new"
  end

  def thank_you
    @page = Page.find_by_link_url("/<%= plural_name %>/thank_you", :include => [:parts, :slugs])
  end

  def new
    @<%= singular_name %> = <%= class_name %>.new
  end

  def create
    @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])

    if @<%= singular_name %>.save
      begin
        <%= class_name %>Mailer.notification(@<%= singular_name %>, request).deliver
      rescue
        logger.warn "There was an error delivering an <%= singular_name %> notification.\n#{$!}\n"
      end<% if @includes_spam %> if @<%= singular_name %>.ham?<% end %>

      begin
        <%= class_name %>Mailer.confirmation(@<%= singular_name %>, request).deliver
      rescue
        logger.warn "There was an error delivering an <%= singular_name %> confirmation:\n#{$!}\n"
      end<% if @includes_spam %> if @<%= singular_name %>.ham?<% end %>

      redirect_to thank_you_<%= plural_name %>_url
    else
      render :action => 'new'
    end
  end

protected

  def find_page
    @page = Page.find_by_link_url('/<%= plural_name %>/new', :include => [:parts, :slugs])
  end

end
