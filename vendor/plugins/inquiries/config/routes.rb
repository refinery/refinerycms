ActionController::Routing::Routes.draw do |map|
  map.new_inquiry '/contact', :controller => "inquiries", :action => "new"
  map.resources :inquiries, :collection => {:thank_you => :get}

  map.with_options(:path_prefix => "refinery", :name_prefix => "admin_", :namespace => "admin/") do |admin|
    admin.resources :inquiries
    admin.resources :inquiry_settings
  end
end
