Rails::Application.routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.resources :refinery_settings, :as => :settings
  end
end
