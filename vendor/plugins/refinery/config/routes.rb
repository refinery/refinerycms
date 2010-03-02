Rails::Application.routes.draw do
  match 'wymiframe', :to => 'application#wymiframe'

  namespace(:admin) do
    resources :refinery_core
  end

  match '/admin/flash',                 :to => 'admin/refinery_core#render_flash_messages'
  match '/admin/update_menu_positions', :to => 'admin/refinery_core#update_plugin_positions'
end
