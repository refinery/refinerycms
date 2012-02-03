Refinery::Core::Engine.routes.draw do
  devise_for :refinery_user,
             :class_name => 'Refinery::User',
             :path => 'refinery/users',
             :controllers => { :registrations => 'refinery/users' },
             :skip => [:registrations],
             :path_names => { :sign_out => 'logout',
                              :sign_in => 'login',
                              :sign_up => 'register' }

  # Override Devise's other routes for convenience methods.
  devise_scope :refinery_user do
    get '/refinery/login', :to => "sessions#new", :as => :new_refinery_user_session
    get '/refinery/logout', :to => "sessions#destroy", :as => :destroy_refinery_user_session
    get '/refinery/users/register' => 'users#new', :as => :new_refinery_user_registration
    post '/refinery/users/register' => 'users#create', :as => :refinery_user_registration
  end

  namespace :admin, :path => 'refinery' do
    resources :users, :except => :show
  end
end
