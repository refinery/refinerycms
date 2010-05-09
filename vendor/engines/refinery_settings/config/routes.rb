Rails::Application.routes.draw do
  namespace(:admin) do
    resources :settings, :as => :refinery_settings, :controller => :refinery_settings
  end
end
