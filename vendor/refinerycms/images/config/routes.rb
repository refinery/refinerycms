Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :images, :except => :show do
      collection do
        get :insert
      end
      member do
        get :url
      end
    end
  end
end
