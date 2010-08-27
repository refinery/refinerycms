Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :images do
      collection do
        get :insert
      end
      member do
        get :url
      end
    end
  end
end
