Refinery::Core::Engine.routes.draw do
  get '/system/images/*dragonfly', :to => Dragonfly[:refinery_images]

  namespace :admin, :path => 'refinery' do
    resources :images, :except => [:show, :edit, :update] do
      get :insert, :on => :collection
    end
  end
end
