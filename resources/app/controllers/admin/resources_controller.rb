class Admin::ResourcesController < Admin::BaseController

  crudify :resource, :order => "updated_at DESC"
  before_filter :init_dialog

  def new
    @resource = Resource.new if @resource.nil?

    @url_override = admin_resources_url(:dialog => from_dialog?)
  end

  def create
    @resource = Resource.create(params[:resource])

    unless params[:insert]
      if @resource.valid?
        flash[:notice] = t('refinery.crudify.created', :what => "'#{@resource.title}'")
        unless from_dialog?
          redirect_to :action => 'index'
        else
          render :text => "<script type='text/javascript'>parent.window.location = '#{admin_resources_url}';</script>"
        end
      else
        self.new # important for dialogs
        render :action => 'new'
      end
    else
      if @resource.valid?
        @resource_id = @resource.id
        @resource = nil
      end
      self.insert
    end
  end

  def index
    if searching?
      search_and_paginate_all_resources
    else
      paginate_all_resources
    end

    if RefinerySetting.find_or_set(:group_resources_by_date_uploaded, true)
      @grouped_resources = group_by_date(@resources)
    end
  end

  def insert
    self.new if @resource.nil?

    @url_override = admin_resources_url(:dialog => from_dialog?, :insert => true)

    if params[:conditions].present?
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

  def init_dialog
    @app_dialog = params[:app_dialog].present?
    @field = params[:field]
    @update_resource = params[:update_resource]
    @update_text = params[:update_text]
    @thumbnail = params[:thumbnail]
    @callback = params[:callback]
    @conditions = params[:conditions]
    @current_link = params[:current_link]
  end

  def restrict_controller
    super unless action_name == 'insert'
  end

  def paginate_resources(conditions={})
    @resources = Resource.paginate   :page => (@paginate_page_number ||= params[:page]),
                                     :conditions => conditions,
                                     :order => 'created_at DESC',
                                     :per_page => Resource.per_page(from_dialog?)
  end

end
