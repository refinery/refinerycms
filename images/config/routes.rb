Rails::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :images do
      collection do
        get :insert
      end
    end
  end
end
