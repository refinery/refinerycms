Refinery::Core::Engine.routes.draw do
  get '/system/resources/*dragonfly', :to => Dragonfly.app(:refinery_resources)

  namespace :admin, :path => Refinery::Core.backend_route do
    resources :resources, :except => :show do
      get :insert, :on => :collection
    end
  end
end
