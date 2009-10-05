class Admin::PagesController < Admin::BaseController

  crudify :page, :conditions => "parent_id IS NULL", :order => "position ASC", :include => [:parts, :slugs, :children, :images]
  
  def index
    if searching?
      @pages = Page.find_with_index params[:search]
    else
      @pages = Page.find_all_by_parent_id(nil, :order => "position ASC")
    end
  end
  
  def new
    @page = Page.new
    RefinerySetting.find_or_set(:default_page_parts, ["body", "side_body"]).each do |page_part|
      @page.parts << PagePart.new(:title => page_part)
    end
  end
  
end