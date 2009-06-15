class Admin::PagesController < Admin::BaseController

  crudify :page, :conditions => "parent_id IS NULL", :order => "position ASC"
  
  def index
    @pages = Page.paginate :page => params[:page],
                  :order => "position ASC",
                  :conditions => "parent_id IS NULL",
                  :include => :children
  end
  
end