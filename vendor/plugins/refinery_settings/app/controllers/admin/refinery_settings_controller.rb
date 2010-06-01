class Admin::RefinerySettingsController < Admin::BaseController

  crudify :refinery_setting, :title_attribute => :title, :order => "name ASC", :searchable => false

  def edit
    @refinery_setting = RefinerySetting.find(params[:id])
    if request.xhr?
      render :layout => false
    end
  end

end
