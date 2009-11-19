ActionController::Routing::Routes.draw do |map|
  map.wymiframe '/wymiframe', :controller => "application", :action => "wymiframe"

  map.namespace(:admin) do |admin|
    admin.resources :refinery_core
  end

  map.connect '/admin/flash', :controller => "admin/refinery_core", :action => "render_flash_messages"
  map.connect '/admin/update_menu_positions', :controller => "admin/refinery_core", :action => "update_plugin_positions"
end
