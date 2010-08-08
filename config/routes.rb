Refinery::Application.routes.draw do |map|

  filter(:refinery_locales)

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'pages#home'

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    root :to => 'dashboard#index'
  end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  # match ':controller/:action/:id'
  # match ':controller/:action/:id.:format'

  # Install the default routes as the lowest priority.

  # Marketable URLs should be appended to routes by the Pages Engine.
  # Catch all routes should be appended to routes by the Core Engine.

end
