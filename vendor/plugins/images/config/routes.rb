ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.resources :images, :collection => {:insert => :get}
  end
end
