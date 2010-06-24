class Admin::RefinerySettingsController < Admin::BaseController

  crudify :refinery_setting, :title_attribute => :title, :order => "name ASC", :searchable => false
          #:conditions => current_user.superuser? ? nil : {:restricted => false}

  def edit
    @refinery_setting = RefinerySetting.find(params[:id])

    render :layout => false if request.xhr?
  end

  def find_all_refinery_settings
    @refinery_settings = RefinerySetting.find :all,
                                              :order => "name ASC",
                                              :conditions => current_user.superuser? ? nil : {:restricted => false}
  end

  def paginate_all_refinery_settings
    @refinery_settings = RefinerySetting.paginate :page => params[:page],
                                                  :order => "name ASC",
                                                  :conditions => current_user.superuser? ? nil : {:restricted => false}
  end

end
