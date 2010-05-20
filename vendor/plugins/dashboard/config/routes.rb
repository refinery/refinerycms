ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :dashboard, :collection => {:update_positions => :post}
  end
end
