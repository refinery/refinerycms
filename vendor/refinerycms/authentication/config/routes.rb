Refinery::Application.routes.draw do

  resource :session
  match '/users/reset/:reset_code', :to => 'users#reset', :as => 'reset_users'
  resources :users, :only => [:new, :create] do
    collection do
      get :forgot
      post :forgot
    end
  end

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :users do
      collection do
        post :update_positions do
          collection do
            get :update_positions
          end
        end
      end
    end
  end

  match '/login',  :to => 'sessions#new',     :as => 'login'
  match '/logout', :to => 'sessions#destroy', :as => 'logout'
end
