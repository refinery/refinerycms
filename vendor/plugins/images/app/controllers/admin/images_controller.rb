class Admin::ImagesController < Admin::BaseController

  crudify :image, :order => "created_at DESC", :conditions => "parent_id is NULL", :sortable => false
  
  def new
    @image = Image.new
    logger.warn("from dialog: #{params}")
    if from_dialog?
      render :layout => 'admin_dialog'
    end
  end
  
  def create
    @image = Image.create(params[:image])
    if not (from_dialog? and params[:insert_dialog])
      if @image.valid?
        flash[:notice] = "'#{@image.title}' was successfully created."
        redirect_to :action => 'index'
      else 
        render :action => 'new'
      end
    else
      # set the last page as the current page for image grid.
      params[:page] = Image.last_page(Image.find_all_by_parent_id(nil, :order => "created_at DESC"), dialog = true)
      paginate_images
      render :action => "insert"
    end
  end
  
protected
  def paginate_images
    @images = Image.paginate :page => params[:page],
                             :conditions => 'parent_id is null',
                             :order => 'created_at DESC',
                             :per_page => Image.per_page(dialog = params[:dialog])
  end
  
end