Refinery::Core::Engine.routes.draw do
  filter(:refinery_locales) if defined?(RoutingFilter::RefineryLocales) # optionally use i18n.
  get 'wymiframe(/:id)', :to => 'fast#wymiframe', :as => :wymiframe
  get 'refinery/message', :to => 'fast#message', :as => :message

  namespace :admin, :path => 'refinery' do
    root :to => 'dashboard#index'
    resources :dialogs, :only => [:index, :show]
  end

  post '/refinery/update_menu_positions', :to => 'admin/core#update_plugin_positions'

  get '/sitemap.xml' => 'sitemap#index', :defaults => { :format => 'xml' }
end
