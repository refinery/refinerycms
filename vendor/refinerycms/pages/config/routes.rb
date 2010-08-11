Refinery::Application.routes.draw do
  resources :pages

  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :pages do
      collection do
        post :update_positions
      end
    end

    resources :page_parts

    resource :pages do
      resources :dialogs, :controller => :pages_dialogs do
        collection do
          get :link_to
          get :test_url
          get :test_email
        end
      end
    end

  end
end
