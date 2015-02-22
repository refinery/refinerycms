Refinery::Core::Engine.routes.draw do
  filter(:refinery_locales) if defined?(RoutingFilter::RefineryLocales) # optionally use i18n.
  get "#{Refinery::Core.backend_route}/message", :to => 'fast#message', :as => :message

  namespace :admin, :path => Refinery::Core.backend_route do
    root to: 'core#index'
    resources :dialogs, :only => [:index, :show]
  end

  get '/sitemap.xml' => 'sitemap#index', :defaults => { :format => 'xml' }
end
