Rails::Application.routes.draw do
  resources :inquiries do
    collection do
      get :thank_you
    end
  end

  namespace(:admin) do
    resources :inquiries
    resources :inquiry_settings
  end
end
