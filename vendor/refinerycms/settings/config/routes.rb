Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :settings, :as => :refinery_settings, :controller => :refinery_settings
  end
end
