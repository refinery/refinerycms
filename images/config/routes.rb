Refinery::Core::Engine.routes.draw do
  get '/system/images/*dragonfly', :to => Dragonfly[:refinery_images]

  namespace :admin, :path => 'refinery' do
    resources :images, :except => :show do
      get :insert, :on => :collection
    end
    post "images/set_flash" => "images#set_flash"
  end
end
