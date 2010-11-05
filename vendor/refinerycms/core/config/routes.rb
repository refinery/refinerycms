Refinery::Application.routes.draw do

  match 'wymiframe(/:id)', :to => 'refinery/fast#wymiframe', :as => :wymiframe

  # TODO: is this needed or it can be removed?
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :refinery_core
  end

  match '/refinery/update_menu_positions', :to => 'admin/refinery_core#update_plugin_positions'

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :dialogs, :only => :show
  end
end
