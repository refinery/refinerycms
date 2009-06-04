class Admin::PagesController < Admin::BaseController

  crudify :page, :conditions => "parent_id IS NULL", :order => "position ASC"
  
  def create
    @page = Page.create(params[:page])
    if @page.valid?
      params[:page_part][:title] = "Body" # default part name
      @page.parts.create(params[:page_part])
      flash[:notice] = "'#{@page.title}' was successfully created."
      redirect_to :action => 'index'
    else 
      render :action => 'new'
    end
  end
  
  def index
    @pages = Page.paginate :page => params[:page],
                  :order => "position ASC",
                  :conditions => "parent_id IS NULL",
                  :include => :children
  end
  
end