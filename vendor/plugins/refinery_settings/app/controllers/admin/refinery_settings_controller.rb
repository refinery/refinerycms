class Admin::RefinerySettingsController < Admin::BaseController

  crudify :refinery_setting, :title_attribute => :title
  
  def index
    @refinery_settings = RefinerySetting.paginate(:all, :order => "name ASC", :page => params[:page])
  end

	def edit
		@refinery_setting = RefinerySetting.find(params[:id])
	end
  
end