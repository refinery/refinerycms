Refinery::Core::Engine.routes.draw do
  root to: 'pages#home', via: :get
  get '/pages/:id', to: 'pages#show', as: :page

  namespace :pages, path: '' do
    namespace :admin, path: Refinery::Core.backend_route do
      scope path: :pages do
        post 'preview', to: 'preview#show', as: :preview_pages
        patch 'preview/*path', to: 'preview#show', as: :preview_page
      end
    end
  end

  namespace :admin, path: Refinery::Core.backend_route do
    get 'pages/*path/edit', to: 'pages#edit', as: 'edit_page'
    get 'pages/*path/children', to: 'pages#children', as: 'children_pages'
    patch 'pages/*path', to: 'pages#update', as: 'update_page'
    delete 'pages/*path', to: 'pages#destroy', as: 'delete_page'

    resources :pages, except: :show do
      post :update_positions, on: :collection
    end

    resources :pages_dialogs, only: [] do
      collection do
        get :link_to
      end
    end

    resources :page_parts, only: [:new, :create, :destroy]
  end
end
