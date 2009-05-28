ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin| 
    admin.resources :images
    admin.resources :images_dialogs, :as => "images/dialogs", :controller => :image_dialogs, :collection => {:insert => :get}
  end
end