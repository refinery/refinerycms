Refinery::Core::Engine.routes.draw do
  root :to => 'pages#home', :via => :get
  get '/pages/:id', :to => 'pages#show', :as => :page

  namespace :pages, :path => '' do
    namespace :admin, :path => Refinery::Core.backend_route do
      scope :path => :pages do
        post 'preview', :to => 'preview#show', :as => :preview_pages
        patch 'preview/*path', :to => 'preview#show', :as => :preview_page
      end
    end
  end

  namespace :admin, :path => Refinery::Core.backend_route do
    get 'pages/*path/edit', :to => 'pages#edit'
    get 'pages/*path/children', :to => 'pages#children', :as => 'children_pages'
    put 'pages/*path', :to => 'pages#update'
    delete 'pages/*path', :to => 'pages#destroy'

    resources :pages, :except => :show do
      post :update_positions, :on => :collection
    end

    resources :pages_dialogs, :only => [] do
      collection do
        get :link_to
      end
    end

    resources :page_parts, :only => [:new, :create, :destroy]
  end
end
