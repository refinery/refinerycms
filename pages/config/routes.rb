Rails.application.routes.draw do
  scope(:module => 'refinery') do
    root :to => 'pages#home'
    get '/pages/:id', :to => 'pages#show', :as => 'refinery_page'

    scope(:module => 'admin', :path => 'refinery', :as => 'refinery_admin') do
      resources :pages, :except => :show do
        collection do
          post :update_positions
        end
      end

      resources :pages_dialogs, :only => [] do
        collection do
          get :link_to
          get :test_url
          get :test_email
        end
      end

      resources :page_parts, :only => [:new, :create, :destroy]
    end
  end
end
