Rails::Application.routes.draw do
  namespace(:admin) do
    resources :refinery_settings, :as => :settings
  end
end
