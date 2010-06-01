Rails::Application.routes.draw do
  scope(:path => 'refinery', :name_prefix => 'admin', :module => 'admin') do
    resources :settings, :as => :refinery_settings, :controller => :refinery_settings
  end
end
