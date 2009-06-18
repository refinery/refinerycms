class Admin::ImagesController < Admin::BaseController

  crudify :image, :order => "created_at DESC", :conditions => "parent_id is NULL", :sortable => false
  
  def new
    @image = Image.new
  end
  
  def insert
    paginate_images
    self.new if @image.nil?
    
    @dialog = params[:dialog] ||= true
    
    render :action => "insert"
  end
  
  def create
    @image = Image.create(params[:image])
    saved = @image.valid?
    flash[:notice] = "'#{@image.title}' was successfully created." if saved
    unless params[:insert]
      if saved
        unless from_dialog?
          redirect_to :action => 'index'
        else
          render :text => "<script type='text/javascript'>parent.window.location = '#{admin_images_url}';</script>"
        end
      else
        render :action => 'new', :layout => (from_dialog? ? 'admin_dialog' : 'admin')
      end
    else
      # set the last page as the current page for image grid.
      params[:page] = Image.last_page(Image.find_all_by_parent_id(nil, :order => "created_at DESC"), params[:dialog])
      @image = nil
      self.insert
    end
  end
  
protected
  def paginate_images
    @images = Image.paginate :page => params[:page],
                             :conditions => 'parent_id is null',
                             :order => 'created_at DESC',
                             :per_page => Image.per_page(params[:dialog])
  end
  
end