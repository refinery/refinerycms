Rails::Application.routes.draw do
  scope(:path => 'refinery', :name_prefix => 'admin', :module => 'admin') do
    resources :dialogs # FIXME: Rails 3, :only => [:show]
  end
end
