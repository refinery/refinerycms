ActionController::Routing::Routes.draw do |map|

  map.resources :resources

  map.with_options(:path_prefix => "refinery", :name_prefix => "admin_", :namespace => "admin/") do |admin|
    admin.resources :resources, :collection => {:insert => :get}
  end

end
