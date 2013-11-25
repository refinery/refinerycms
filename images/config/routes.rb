Refinery::Core::Engine.routes.draw do
  get '/system/images/*dragonfly', :to => Dragonfly.app(:refinery_images)

  namespace :admin, :path => Refinery::Core.backend_route do
    resources :images, :except => :show do
      get :insert, :on => :collection
    end
  end
end
