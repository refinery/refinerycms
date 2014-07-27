Refinery::Core::Engine.routes.draw do
  filter(:refinery_locales) if defined?(RoutingFilter::RefineryLocales) # optionally use i18n.
  get "#{Refinery::Core.backend_route}/message", :to => 'fast#message', :as => :message

  namespace :admin, :path => Refinery::Core.backend_route do
    root :to => 'pages#index' # TODO WIP
    resources :dialogs, :only => [:index, :show]
  end

  post "/#{Refinery::Core.backend_route}/update_menu_positions", :to => 'admin/core#update_plugin_positions'

  get '/sitemap.xml' => 'sitemap#index', :defaults => { :format => 'xml' }
end
