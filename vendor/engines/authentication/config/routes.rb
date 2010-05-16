Rails::Application.routes.draw do

  resource :session
  resources :users, :only => [:new, :create] do
    collection do
      get :forgot
      get :reset
    end
  end
  match '/users/reset/:reset_code', :to => 'users#reset', :as => 'reset_users'

  namespace(:admin) do
    resources :users
  end

  match '/login',  :to => 'sessions#new',     :as => 'login'
  match '/logout', :to => 'sessions#destroy', :as => 'logout'

end
