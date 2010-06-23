ActionController::Routing::Routes.draw do |map|
  map.wymiframe '/wymiframe/:id', :controller => "refinery/fast", :action => "wymiframe"

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :refinery_core
  end

  map.connect '/refinery/flash', :controller => "admin/refinery_core", :action => "render_flash_messages"
  map.connect '/refinery/update_menu_positions', :controller => "admin/refinery_core", :action => "update_plugin_positions"
end
