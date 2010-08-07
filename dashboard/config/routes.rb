Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resource :dashboard, :controller => 'dashboard'
    match 'disable_upgrade_message', :to => 'dashboard#disable_upgrade_message', :as => :disable_upgrade_message
  end
end
