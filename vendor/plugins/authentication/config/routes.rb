Rails::Application.routes.draw do

  resources :users
  resource :session

  namespace(:admin) do
    resources :users
  end

  match 'login',  :to => 'sessions#new'
  match 'logout', :to => 'sessions#destroy'
  match 'forgot', :to => 'users#forgot'
  match 'reset/:reset_code', :to => 'users#reset'

end
