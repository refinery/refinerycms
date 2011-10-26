Rails.application.routes.draw do
  filter(:refinery_locales) if defined?(RoutingFilter::RefineryLocales) # optionally use i18n.
  scope(:module => 'refinery') do
    match 'wymiframe(/:id)', :to => 'fast#wymiframe', :as => :wymiframe

    scope(:path => 'refinery', :as => 'refinery_admin', :module => 'admin') do
      resources :dialogs, :only => :show
      root :to => 'dashboard#index'
    end

    match '/refinery/update_menu_positions', :to => 'admin/refinery_core#update_plugin_positions'

    match '/sitemap.xml' => 'sitemap#index', :defaults => { :format => 'xml' }

    # Marketable URLs should be appended to routes by the Pages Engine.
    # Catch all routes should be appended to routes by the Core Engine.
  end

  get '/favicon.ico' => redirect('/assets/favicon.ico')
end
