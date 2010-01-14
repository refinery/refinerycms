ActionController::Routing::Routes.draw do |map|

  map.namespace(:admin) do |admin|
    admin.resources :themes
  end

 	map.connect 'stylesheets/theme/:filename*extension', :controller => 'themes', :action => 'stylesheets'
  map.connect 'javascripts/theme/:filename*extension', :controller => 'themes', :action => 'javascripts'
  map.connect 'images/theme/:filename*extension', :controller => 'themes', :action => 'images'

end