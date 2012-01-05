Refinery::Core::Engine.routes.draw do
  filter(:refinery_locales) if defined?(RoutingFilter::RefineryLocales) # optionally use i18n.
  match 'wymiframe(/:id)', :to => 'fast#wymiframe', :as => :wymiframe

  namespace :admin, :path => 'refinery' do
    root :to => 'dashboard#index'
    resources :dialogs, :only => :show
  end

  match '/refinery/update_menu_positions', :to => 'admin/refinery_core#update_plugin_positions'

  match '/sitemap.xml' => 'sitemap#index', :defaults => { :format => 'xml' }


  get '/favicon.ico' => redirect('/assets/favicon.ico')
end
