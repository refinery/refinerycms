Rails::Application.routes.draw do

  resources :users
  resource :session

  namespace(:admin) do
    resources :users
  end

  match '/login',  :to => 'sessions#new',     :as => 'login'
  match '/logout', :to => 'sessions#destroy', :as => 'logout'
  match '/forgot', :to => 'users#forgot',     :as => 'forgot'
  match '/reset/:reset_code', :to => 'users#reset', :as => 'reset'

end
