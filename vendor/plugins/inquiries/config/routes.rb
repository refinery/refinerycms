ActionController::Routing::Routes.draw do |map|
  map.resources :inquiries, :collection => {:thank_you => :get}

  map.namespace(:admin) do |admin|
    admin.resources :inquiries, :member => {:toggle_status => :get}
    admin.resources :inquiry_settings
  end
end
