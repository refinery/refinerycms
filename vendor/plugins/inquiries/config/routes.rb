ActionController::Routing::Routes.draw do |map|
  map.new_inquiry '/contact', :controller => "inquiries", :action => "new"
  map.resources :inquiries, :collection => {:thank_you => :get}

  map.namespace(:admin) do |admin|
    admin.resources :inquiries
    admin.resources :inquiry_settings
  end
end
