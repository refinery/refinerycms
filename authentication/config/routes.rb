Refinery::Core::Engine.routes.draw do
  begin
    require 'devise'

    # Override Devise's other routes for convenience methods.
    devise_scope :refinery_user do
      get "/#{Refinery::Core.backend_route}/login", :to => "sessions#new", :as => :login
      get "/#{Refinery::Core.backend_route}/logout", :to => "sessions#destroy", :as => :logout
      get "/#{Refinery::Core.backend_route}/users/register" => 'users#new', :as => :signup
      post "/#{Refinery::Core.backend_route}/users/register" => 'users#create', :as => :signup
    end

    devise_for :refinery_user,
               :class_name => 'Refinery::User',
               :path => "#{Refinery::Core.backend_route}/users",
               :controllers => { :registrations => 'refinery/users' },
               :skip => [:registrations],
               :path_names => { :sign_out => 'logout',
                                :sign_in => 'login',
                                :sign_up => 'register' }
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

  namespace :admin, :path => Refinery::Core.backend_route do
    resources :users, :except => :show
  end
end
