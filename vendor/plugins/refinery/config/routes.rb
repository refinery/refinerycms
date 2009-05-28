ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin| 
    admin.resources :refinery_core
  end
  
  map.connect '/admin/update_menu_positions', :controller => "admin/refinery_core", :action => "update_plugin_positions"
end