class Admin::RefinerySettingsController < Admin::BaseController

  crudify :refinery_setting, :title_attribute => :title, :order => "name ASC", :searchable => false
  
end