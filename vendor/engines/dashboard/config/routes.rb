Rails::Application.routes.draw do
  scope(:path => 'refinery', :name_prefix => 'admin', :module => 'admin') do
    resources :dashboard, :controller => 'dashboard'
  end
end
