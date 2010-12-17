Refinery::Application.routes.draw do
  
  # Add Devise necessary routes.
  # For Devise routes, see: https://github.com/plataformatec/devise
  devise_for :users, :controllers => {:sessions => "sessions", :registrations => "registrations"}
  
  # Override Devise's default after login redirection route.  This will pushed a logged in user to the dashboard.
  match '/refinery', :to => 'admin/dashboard#index', :as => 'user_root'
  
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :users, :except => :show
  end
  
end
