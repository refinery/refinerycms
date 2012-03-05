Refinery::Core::Engine.routes.prepend do
  match '/system/resources/*dragonfly', :to => Dragonfly[:refinery_resources]

  namespace :admin, :path => 'refinery' do
    resources :resources, :except => :show do
      get :insert, :on => :collection
    end
  end
end
