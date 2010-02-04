class Admin::ImagesController < Admin::BaseController

  include Admin::ImagesHelper

  crudify :image, :order => "created_at DESC", :conditions => "parent_id is NULL", :sortable => false
  before_filter :change_list_mode_if_specified, :init_dialog

  def index
    if searching?
      @images = Image.paginate_search params[:search],
                                               :page => params[:page],
                                               :order => "created_at DESC",
                                               :conditions => "parent_id IS NULL"
    else
      @images = Image.paginate :page => params[:page],
                                               :order => "created_at DESC",
                                               :conditions => "parent_id IS NULL"
    end

    if RefinerySetting.find_or_set(:group_images_by_date_uploaded, true)
      @grouped_images = []
      @images.each do |image|
        key = image.created_at.strftime("%Y-%m-%d")
        image_group = @grouped_images.collect{|images| images.last if images.first == key }.flatten.compact << image
        (@grouped_images.delete_if {|i| i.first == key}) << [key, image_group]
      end
    end
  end

  def new
    @image = Image.new unless @image.present?

    @url_override = admin_images_url(:dialog => from_dialog?)
  end

  def insert
    self.new if @image.nil?

    @url_override = admin_images_url(:dialog => from_dialog?, :insert => true)

    unless params[:conditions].blank?
      extra_condition = params[:conditions].split(',')

      extra_condition[1] = true if extra_condition[1] == "true"
      extra_condition[1] = false if extra_condition[1] == "false"
      extra_condition[1] = nil if extra_condition[1] == "nil"
      paginate_images({extra_condition[0].to_sym => extra_condition[1]})
    else
      paginate_images
    end

    render :action => "insert"
  end

  def create
    @image = Image.create(params[:image])

    unless params[:insert]
      if @image.valid?
        flash[:notice] = "'#{@image.title}' was successfully created."
        unless from_dialog?
          redirect_to :action => 'index'
        else
          render :text => "<script type='text/javascript'>parent.window.location = '#{admin_images_url}';</script>"
        end
      else
        self.new # important for dialogs
        render :action => 'new'
      end
    else
      @image_id = @image.id
      @image = nil
      self.insert
    end
  end

protected

  def init_dialog
    @thickbox = params[:thickbox].present?
    @field = params[:field]
    @update_image = params[:update_image]
    @thumbnail = params[:thumbnail]
    @callback = params[:callback]
    @conditions = params[:conditions]
  end

  def paginate_images(conditions={})
    @images = Image.paginate   :page => (@paginate_page_number ||= params[:page]),
                               :conditions => {:parent_id => nil}.merge!(conditions),
                               :order => 'created_at DESC',
                               :per_page => Image.per_page(from_dialog?),
                              :include => :thumbnails
  end

end
