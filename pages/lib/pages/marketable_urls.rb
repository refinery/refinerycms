# You need to restart the server after changing this setting.
if ::Refinery::Pages.use_marketable_urls?
  ::Refinery::Application.routes.append do
    scope(:module => 'refinery') do
      get '*path', :to => 'pages#show'
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
