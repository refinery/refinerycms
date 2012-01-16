Rails.application.routes.draw do
  match '/system/images/*dragonfly', :to => Dragonfly[:refinery_images]

  scope(:path => 'refinery', :as => 'refinery_admin', :module => 'refinery/admin') do
    resources :images, :except => :show do
      collection do
        get :insert
      end
    end
  end
end
