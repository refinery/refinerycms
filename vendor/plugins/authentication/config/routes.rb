ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :session

  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
end