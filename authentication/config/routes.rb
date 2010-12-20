::Refinery::Application.routes.draw do

  resource :session, :only => [:new, :create, :destroy]
  match '/users/reset/:reset_code', :to => 'users#reset', :as => 'reset_users'
  resources :users, :only => [:new, :create] do
    collection do
      get :forgot
      post :forgot
    end
  end

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :users, :except => :show
  end

  match '/login',  :to => 'sessions#new',     :as => 'login'
  match '/logout', :to => 'sessions#destroy', :as => 'logout'
end
