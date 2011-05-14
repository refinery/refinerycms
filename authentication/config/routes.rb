::Refinery::Application.routes.draw do

  # Add Devise necessary routes.
  # For Devise routes, see: https://github.com/plataformatec/devise
  devise_for :users, :controllers => {
    :sessions => 'sessions',
    :registrations => 'users',
    :passwords => 'passwords'
  }, :path_names => {
    :sign_out => 'logout',
    :sign_in => 'login',
    :sign_up => 'register'
  }

  # Override Devise's default after login redirection route.  This will pushed a logged in user to the dashboard.
  get 'refinery', :to => 'admin/dashboard#index', :as => :refinery_root
  get 'refinery', :to => 'admin/dashboard#index', :as => :user_root

  # Override Devise's other routes for convenience methods.
  #get 'refinery/login', :to => "sessions#new", :as => :new_user_session
  #get 'refinery/login', :to => "sessions#new", :as => :refinery_login
  #get 'refinery/logout', :to => "sessions#destroy", :as => :destroy_user_session
  #get 'refinery/logout', :to => "sessions#destroy", :as => :logout

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :users, :except => :show
  end

end
