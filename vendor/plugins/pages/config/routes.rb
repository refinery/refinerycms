Rails::Application.routes.draw do
  resources :pages

  namespace(:admin) do
    resources :pages
    resources :page_parts

    resources :pages_dialogs, :as => "pages/dialogs", :controller => :page_dialogs do
      collection do
        get :link_to
        get :test_url
        get :test_email
      end
    end

  end
end
