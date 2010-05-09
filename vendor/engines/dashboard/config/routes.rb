Rails::Application.routes.draw do
  namespace(:admin) do
    resources :dashboard, :controller => 'dashboard'
  end
end
