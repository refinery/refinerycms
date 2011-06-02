::Refinery::Application.routes.draw do
  match '*path' => 'refinery/pages#show'
end

# Add any parts of routes as reserved words.
if ::Refinery::Page.use_marketable_urls?
  ::Refinery::Page.friendly_id_config.reserved_words |= ::Refinery::Application.routes.named_routes.map { |name, route|
    route.path.gsub(/^\//, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
  }.flatten.reject{|w| w =~ /\_/}.uniq
end
