ActionController::Routing::Routes.draw do |map|
  map.resources :resources

  map.namespace(:admin) do |admin| 
    admin.resources :resources, :collection => {:insert => :get}
  end
end