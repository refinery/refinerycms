ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :dashboard
    admin.disable_upgrade_message 'disable_upgrade_message', :controller => 'dashboard', :action => 'disable_upgrade_message'
  end
end
