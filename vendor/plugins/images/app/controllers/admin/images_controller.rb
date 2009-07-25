class Admin::ImagesController < Admin::BaseController

  crudify :image, :order => "created_at DESC", :conditions => "parent_id is NULL", :sortable => false
  before_filter :change_list_mode_if_specified
  
  def new
    @image = Image.new
    
    @url_override = admin_images_url(:dialog => from_dialog?)
  end
  
  def insert
    self.new if @image.nil?
    @dialog = params[:dialog] ||= true
    @thickbox = !params[:thickbox].blank?
    @field = params[:field]
    @update_image = params[:update_image]
    @thumbnail = params[:thumbnail]
    @callback = params[:callback]
    @url_override = admin_images_url(:dialog => @dialog, :insert => true)
    
    paginate_images
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
        render :action => 'new'
      end
    else
      # set the last page as the current page for image grid.
      #@paginate_page_number = Image.last_page(Image.find_all_by_parent_id(nil, :order => "created_at DESC"), params[:dialog])
      # currently images are sorting by date desc so the first page is always the selected page now.
      @image_id = @image.id
      @image = nil
      self.insert
    end
  end
  
protected
  def paginate_images
    @images = Image.paginate :page => (@paginate_page_number ||= params[:page]),
                             :conditions => 'parent_id is null',
                             :order => 'created_at DESC',
                             :per_page => Image.per_page(params[:dialog])
  end
  
  def change_list_mode_if_specified
    if params[:action] == "index" and not params[:view].blank?
      session[:image_view] = params[:view] if ["grid", "list"].include?(params[:view])
    end
  end
  
end