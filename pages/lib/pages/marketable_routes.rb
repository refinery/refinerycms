::Refinery::Application.routes.draw do
  match '*path' => 'pages#show'
end

# Add any parts of routes as reserved words.
if Page.use_marketable_urls?
  named_routes = ::Refinery::Application.routes.named_routes
  Page.friendly_id_config.reserved_words |= named_routes.map { |name|
    named_routes[name].path.gsub(/^\//, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
  }.flatten.reject{|w| w =~ /\_/}.uniq
end
