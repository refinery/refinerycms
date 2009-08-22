class Admin::PagesController < Admin::BaseController

  crudify :page, :conditions => "parent_id IS NULL", :order => "position ASC", :include => [:parts, :slugs, :children, :images]
  
  def index
    @pages = Page.paginate :page => params[:page],
                  :order => "position ASC",
                  :conditions => "parent_id IS NULL",
                  :include => [:parts, :slugs]
  end
  
  def new
    @page = Page.new
    RefinerySetting.find_or_set(:default_page_parts, ["body", "side_body"]).each do |page_part|
      @page.parts << PagePart.new(:title => page_part)
    end
  end
  
end