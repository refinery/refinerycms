ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :dialogs, :only => [:show], :collection => {:update_positions => :post}
  end
end
