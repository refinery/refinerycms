Rails.application.routes.draw do
  match '/system/resources/*dragonfly', :to => Dragonfly[:resources]

  scope(:path => 'refinery', :as => 'refinery_admin', :module => 'refinery/admin') do
    resources :resources, :except => :show do
      collection do
        get :insert
      end
    end
  end
end
