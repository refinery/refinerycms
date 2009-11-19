class <%= class_name.pluralize %>Controller < ApplicationController

  before_filter :find_page

  def index
    @<%= plural_name %> = <%= class_name %>.find(:all, :order => "position ASC")
  end

  def show
    @<%= plural_name %> = <%= class_name %>.find(:all, :order => "position ASC") # for body_content_right
    @<%= singular_name %> = <%= class_name %>.find(params[:id])
  end

protected

  def find_page
    @page = Page.find_by_link_url("/<%= plural_name %>")
  end

end
