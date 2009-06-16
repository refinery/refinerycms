class Admin::PagesController < Admin::BaseController

  crudify :page, :conditions => "parent_id IS NULL", :order => "position ASC"
  
  def index
    @pages = Page.paginate :page => params[:page],
                  :order => "position ASC",
                  :conditions => "parent_id IS NULL",
                  :include => :children
  end
  
  def new
    @page = Page.new
    (RefinerySetting[:default_page_parts] ||= ["body", "side_body"]).each do |page_part|
      @page.parts << PagePart.new(:title => page_part)
    end
  end
  
end