ActionController::Routing::Routes.draw do |map|
  map.resources :news_items, :as => :news

  map.namespace(:admin) do |admin|
    admin.resources :news_items, :as => :news
  end
end
