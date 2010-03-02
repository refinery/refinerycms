Rails::Application.routes.draw do
  resources :news_items, :as => :news

  namespace(:admin) do
    resources :news_items, :as => :news
  end
end
