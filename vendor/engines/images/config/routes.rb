Rails::Application.routes.draw do
  namespace(:admin) do
    resources :images do
      collection do
        get :insert
      end
    end
  end
end
