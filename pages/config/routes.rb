::Refinery::Application.routes.draw do
  scope(:as => 'refinery_page', :module => 'refinery') do
    get '/pages/:id', :to => 'pages#show'
  end

  scope(:path => 'refinery', :as => 'refinery_admin', :module => 'refinery/admin') do
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
