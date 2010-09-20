class <%= class_name.pluralize %>Controller < ApplicationController

  before_filter :find_all_<%= plural_name %>
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @<%= singular_name %> in the line below:
    present(@page)
  end

  def show
    @<%= singular_name %> = <%= class_name %>.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @<%= singular_name %> in the line below:
    present(@page)
  end

protected

  def find_all_<%= plural_name %>
    @<%= plural_name %> = <%= class_name %>.find(:all, :order => "position ASC")
  end

  def find_page
    @page = Page.find_by_link_url("/<%= plural_name %>")
  end

end
