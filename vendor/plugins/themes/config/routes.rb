ActionController::Routing::Routes.draw do |map|

  map.namespace(:admin) do |admin|
    admin.resources :themes, :member => {:preview_image => :get, :activate => :get}
  end

	# allows theme files that are not in the Rails public directory to be served back to the client
  map.connect 'theme/stylesheets/*filepath', :controller => 'themes', :action => 'stylesheets'
  map.connect 'theme/javascripts/*filepath', :controller => 'themes', :action => 'javascripts'
  map.connect 'theme/images/*filepath', :controller => 'themes', :action => 'images'

end