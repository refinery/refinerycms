ActionController::Routing::Routes.draw do |map|
  map.resources :pages

  map.namespace(:admin, :path_prefix => 'refinery') do |admin|
    admin.resources :pages, :collection => {:update_positions => :post}, :collection => {:update_positions => :post}
    admin.resources :page_parts, :collection => {:update_positions => :post}

    admin.resources :pages_dialogs, :as => "pages/dialogs", :controller => :page_dialogs,
                    :collection => {:link_to => :get, :test_url => :get, :test_email => :get}
  end
end
