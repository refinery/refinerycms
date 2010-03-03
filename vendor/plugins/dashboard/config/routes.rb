Rails::Application.routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.resources :dashboard
  end
  #namespace(:admin) do
  #  resources :dashboard
  #end
end
