Refinery::Core::Engine.routes.draw do
  namespace :admin, :path => 'refinery' do
    get 'dashboard', :to => 'dashboard#index', :as => :dashboard

    match 'disable_upgrade_message',
          :to => 'dashboard#disable_upgrade_message',
          :as => :disable_upgrade_message
  end
end
