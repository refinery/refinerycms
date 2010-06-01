ActionController::Routing::Routes.draw do |map|
  map.filter(:locale)

  # NB: Engine routes are loaded FIRST from Rails v2.3 onward.
  # These routes are contained within vendor/plugins/engine_name/config/routes.rb

  # The priority is based upon order of creation: first created -> highest priority.
  map.root :controller => "pages", :action => "home"

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
  end

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'


  map.redirect 'admin/*path', :controller => 'admin/base'
  map.connect 'refinery/*path', :controller => 'admin/base', :action => 'error_404'

  # Marketable URLs
  map.connect '*path', :controller => 'pages', :action => 'show'

end
