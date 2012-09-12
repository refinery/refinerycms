Refinery::Core::Engine.routes.draw do
  namespace :admin, :path => 'refinery' do
    get 'dashboard', :to => 'dashboard#index', :as => :dashboard
  end
end
