class LayoutsController < ApplicationController

  before_filter :find_all_layouts
  before_filter :find_page

  def index
    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @layout in the line below:
    present(@page)
  end

  def show
    @layout = Layout.find(params[:id])

    # you can use meta fields from your model instead (e.g. browser_title)
    # by swapping @page for @layout in the line below:
    present(@page)
  end

protected

  def find_all_layouts
    @layouts = Layout.order('position ASC')
  end

  def find_page
    @page = Page.where(:link_url => "/layouts").first
  end

end
