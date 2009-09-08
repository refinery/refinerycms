class Admin::ResourcesController < Admin::BaseController
  
  crudify :resource, :order => "updated_at DESC"
  
	def new
		@resource = Resource.new
		
    @url_override = admin_resources_url(:dialog => from_dialog?)
	end
	
	def create
    @resource = Resource.create params[:resource]
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
  end

end