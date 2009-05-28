class Admin::PagePartsController < Admin::BaseController

  layout 'admin_dialog'

  crudify :page_part, :order => "position ASC"
  
  def new
    @page = Page.find(params[:page_id])
    @page_part = @page.parts.new
  end
  
  def create
    @page = Page.find(params[:page_id])
    @page_part = @page.parts.new(params[:page_part])
    
    if @page_part.save  
      redirect_to edit_admin_page_url(@page)
    else
      flash[:error] = "You must enter a title for the part to be added to this page"
      redirect_to edit_admin_page_url(@page)
    end
  end
  
end