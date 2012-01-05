Refinery::Core::Engine.routes.draw do
  root :to => 'pages#home'
  get '/pages/:id', :to => 'pages#show', :as => :page

  namespace :admin, :path => 'refinery' do
    resources :pages, :except => :show do
      post :update_positions, :on => :collection
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
