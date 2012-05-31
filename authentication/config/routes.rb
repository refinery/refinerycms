Refinery::Core::Engine.routes.draw do
  begin
    require 'devise'
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
      get '/refinery/login', :to => "sessions#new", :as => :login
      get '/refinery/logout', :to => "sessions#destroy", :as => :logout
      get '/refinery/users/register' => 'users#new', :as => :signup
      post '/refinery/users/register' => 'users#create', :as => :signup
    end
  rescue RuntimeError => exc
    if exc.message =~ /ORM/
      # We don't want to complain on a fresh installation.
      if (ARGV || []).exclude?('--fresh-installation')
        puts "---\nYou can safely ignore the following warning if you're currently installing Refinery as Devise support files have not yet been copied to your application:\n\n"
        puts exc.message
        puts '---'
      end
    else
      raise exc
    end
  end

  namespace :admin, :path => 'refinery' do
    resources :users, :except => :show
  end
end
