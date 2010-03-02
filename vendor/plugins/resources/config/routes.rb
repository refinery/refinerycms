Rails::Application.routes.draw do

  resources :resources

  namespace(:admin) do
    resources :resources do
      collection do
        get :insert
      end
    end
  end

end
