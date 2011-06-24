# Determines whether marketable urls are in use.
if ::Refinery::Page.use_marketable_urls?
  ::Refinery::Application.routes.draw do
    scope(:module => 'refinery') do
      match '*path' => 'pages#show'
    end
  end

  ::Refinery::Application.config.after_initialize do
    # Add any parts of routes as reserved words.
    route_paths = ::Refinery::Application.routes.named_routes.routes.map{|name, route| route.path}
    ::Refinery::Page.friendly_id_config.reserved_words |= route_paths.map { |path|
      path.to_s.gsub(/^\//, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
    }.flatten.reject{|w| w =~ /\_/}.uniq
  end
end
