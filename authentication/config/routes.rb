::Refinery::Application.routes.draw do

  # Add Devise necessary routes.
  # For Devise routes, see: https://github.com/plataformatec/devise
  scope(:module => Refinery) do
    devise_for :users, :class_name => "Refinery::User", :module => Refinery, :controllers => {
      :sessions => 'refinery/sessions',
      :registrations => 'refinery/users',
      :passwords => 'reginery/passwords'
    }, :path_names => {
      :sign_out => 'logout',
      :sign_in => 'login',
      :sign_up => 'register'
    }
  end

  # Override Devise's default after login redirection route.  This will pushed a logged in user to the dashboard.
  scope(:module => Refinery) do
    get 'refinery', :to => 'admin/dashboard#index', :as => :refinery_root
    get 'refinery', :to => 'dashboard#index', :as => :user_root
  end
  # Override Devise's other routes for convenience methods.
  #get 'refinery/login', :to => "sessions#new", :as => :new_user_session
  #get 'refinery/login', :to => "sessions#new", :as => :refinery_login
  #get 'refinery/logout', :to => "sessions#destroy", :as => :destroy_user_session
  #get 'refinery/logout', :to => "sessions#destroy", :as => :logout

  scope(:path => 'refinery', :as => 'admin', :module => Refinery::Admin) do
    resources :users, :except => :show
  end

end
