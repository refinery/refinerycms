Rails::Application.routes.draw do
  scope(:path => 'refinery', :name_prefix => 'admin', :module => 'admin') do
    resources :dashboard, :controller => 'dashboard'
    match 'disable_upgrade_message', :to => 'dashboard#disable_upgrade_message', :as => :disable_upgrade_message
  end
end
