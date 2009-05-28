class Admin::ResourcesController < Admin::BaseController
  
  crudify :resource, :order => "updated_at DESC"
  
end