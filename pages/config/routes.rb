Refinery::Core::Engine.routes.draw do
  root :to => 'pages#home'
  get '/pages/:id', :to => 'pages#show', :as => :page

  namespace :admin, :path => 'refinery' do
    get 'pages/*path/edit', :to => 'pages#edit'
    put 'pages/*path', :to => 'pages#update'
    delete 'pages/*path', :to => 'pages#destroy'
    resources :pages, :except => :show do
      post :update_positions, :on => :collection
      get :children, :on => :member
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
