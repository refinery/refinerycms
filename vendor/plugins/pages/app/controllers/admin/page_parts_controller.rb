class Admin::PagePartsController < Admin::BaseController

  layout 'admin_dialog'

  crudify :page_part, :order => "position ASC"
  
  def new
    @page = Page.find(params[:page_id], :include => [:parts, :slugs, :children])
    @page_part = @page.parts.new
  end
  
  def create
    @page = Page.find(params[:page_id], :include => [:parts, :slugs, :children])
    @page_part = @page.parts.new(params[:page_part])
    @page_part.title = @page_part.title.downcase.gsub(" ", "_")
    
    saved = @page_part.save
    flash[:error] = "You must enter a title for the part to be added to this page" unless saved
    
    unless request.xhr?
      redirect_to edit_admin_page_url(@page)
    else
      if saved
        flash.now[:notice] = "The new content section was added. Please close this dialog and reload the page to use it. Make sure you save any changes you have made."
      end

      render :update do |page|
        page.replace_html 'flash_container', :partial => "/shared/message"
        page[:flash].appear
      end
      flash.discard # Get rid of the flash message, we don't need it anymore.. otherwise it'll show up on next page load.
    end
  end
  
end