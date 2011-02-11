::Refinery::Application.routes.draw do

  match '/system/resources/*dragonfly', :to => Dragonfly[:resources]

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :resources, :except => :show do
      collection do
        get :insert
      end
    end
  end

end
