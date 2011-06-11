::Refinery::Application.routes.draw do

  # Add Devise necessary routes.
  # For Devise routes, see: https://github.com/plataformatec/devise
  scope(:module => 'refinery') do
    devise_for :'refinery/users', :class_name => "::Refinery::User", :module => 'refinery', :controllers => {
      :sessions => 'refinery/sessions',
      :registrations => 'refinery/users',
      :passwords => 'refinery/passwords'
    }, :path_names => {
      :sign_out => 'logout',
      :sign_in => 'login',
      :sign_up => 'register'
    }
  end

  # Override Devise's default after login redirection route.
  # This will push a logged in user to the dashboard.
  scope(:module => 'refinery/admin') do
    get 'refinery', :to => 'dashboard#index', :as => :refinery_root
    get 'refinery', :to => 'dashboard#index', :as => :user_root
  end
  # Override Devise's other routes for convenience methods.
  #get 'refinery/login', :to => "sessions#new", :as => :new_user_session
  #get 'refinery/login', :to => "sessions#new", :as => :refinery_login
  #get 'refinery/logout', :to => "sessions#destroy", :as => :destroy_user_session
  #get 'refinery/logout', :to => "sessions#destroy", :as => :logout

  scope(:path => 'refinery', :as => 'refinery_admin', :module => 'refinery/admin') do
    resources :users, :except => :show
  end

end
