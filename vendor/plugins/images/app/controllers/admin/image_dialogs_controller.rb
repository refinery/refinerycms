class Admin::ImageDialogsController < Admin::DialogsController

  crudify :image

  def insert
    paginate_images
    self.new if @image.nil?
  end
  
  def new
    @image = Image.new
  end
  
  def create
    @image = Image.create(params[:image])
    
    # set the last page as the current page for image grid.
    params[:page] = Image.last_page(Image.find_all_by_parent_id(nil, :order => "created_at DESC"), dialog = true)
    paginate_images
    render :action => "insert"
  end
  
protected

  def paginate_images
    @images = Image.paginate :page => params[:page],
                             :conditions => 'parent_id is null',
                             :order => 'created_at DESC',
                             :per_page => Image.per_page(dialog = true)
  end
  
end