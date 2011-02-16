::Refinery::Application.routes.draw do
  match '*path' => 'pages#show'
end

# Add any parts of routes as reserved words.
if Page.use_marketable_urls?
  Page.friendly_id_config.reserved_words |= ::Refinery::Application.routes.named_routes.map { |name, route|
    route.path.gsub(/^\//, '').to_s.split('(').first.split(':').first.to_s.split('/')
  }.flatten.uniq
end
