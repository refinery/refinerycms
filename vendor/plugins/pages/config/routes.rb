ActionController::Routing::Routes.draw do |map|
  map.resources :pages

  map.namespace(:admin) do |admin| 
  	admin.resources :pages do |page|
    	page.resources :page_parts
    end
    
    admin.resources :pages_dialogs, :as => "pages/dialogs", :controller => :page_dialogs,
                    :collection => {:link_to => :get, :test_url => :get, :test_email => :get}
  end
end