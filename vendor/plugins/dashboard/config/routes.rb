Rails::Application.routes.draw do
  namespace(:admin) do
    resources :dashboard
  end
end
