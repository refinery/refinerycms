ActionController::Routing::Routes.draw do |map|
  map.new_inquiry '/contact', :controller => "inquiries", :action => "new"
  map.resources :inquiries, :collection => {:thank_you => :get}

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :inquiries, :collection => {:update_positions => :post}
    admin.resources :inquiry_settings, :collection => {:update_positions => :post}
  end
end
