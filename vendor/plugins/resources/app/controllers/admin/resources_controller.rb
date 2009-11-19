class Admin::ResourcesController < Admin::BaseController

  crudify :resource, :order => "updated_at DESC"

  def new
    @resource = Resource.new

    @url_override = admin_resources_url(:dialog => from_dialog?)
  end

  def create
    @resource = Resource.create params[:resource]

    unless params[:insert]
      if @resource.valid?
        flash[:notice] = "'#{@resource.title}' was successfully created."
        unless from_dialog?
          redirect_to :action => 'index'
        else
          render :text => "<script type='text/javascript'>parent.window.location = '#{admin_resources_url}';</script>"
        end
      else
        render :action => 'new'
      end
    else
      @resource_id = @resource.id
      @resource = nil
      self.insert
    end
  end

  def index
    if searching?
      @resources = Resource.paginate_search params[:search],
                                            :page => params[:page],
                                            :order => "created_at DESC"
    else
      @resources = Resource.paginate  :page => params[:page],
                                      :order => "created_at DESC"
    end

    if RefinerySetting.find_or_set(:group_resources_by_date_uploaded, true)
      @grouped_resources = []
      @resources.each do |resource|
        key = resource.created_at.strftime("%Y-%m-%d")
        resource_group = @grouped_resources.collect{|resources| resources.last if resources.first == key }.flatten.compact << resource
        (@grouped_resources.delete_if {|i| i.first == key}) << [key, resource_group]
      end
    end
  end

  def insert
    self.new if @resource.nil?
    @dialog = from_dialog?
    @thickbox = !params[:thickbox].blank?
    @field = params[:field]
    @update_resource = params[:update_resource]
    @update_text = params[:update_text]
    @thumbnail = params[:thumbnail]
    @callback = params[:callback]
    @conditions = params[:conditions]
    @current_link = params[:current_link]
    @url_override = admin_resources_url(:dialog => @dialog, :insert => true)

    unless params[:conditions].blank?
      extra_condition = params[:conditions].split(',')

      extra_condition[1] = true if extra_condition[1] == "true"
      extra_condition[1] = false if extra_condition[1] == "false"
      extra_condition[1] = nil if extra_condition[1] == "nil"
      paginate_resources({extra_condition[0].to_sym => extra_condition[1]})
    else
      paginate_resources
    end
    render :action => "insert"
  end

protected

  def paginate_resources(conditions={})
    @resources = Resource.paginate   :page => (@paginate_page_number ||= params[:page]),
                                     :conditions => conditions,
                                     :order => 'created_at DESC',
                                     :per_page => Resource.per_page(from_dialog?)
  end

end
