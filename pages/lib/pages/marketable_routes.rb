::Refinery::Application.routes.draw do
  scope(:as => 'refinery_page', :module => 'refinery') do
    match '*path' => 'pages#show'
  end
end

# Add any parts of routes as reserved words.
if ::Refinery::Page.use_marketable_urls?
  ::Refinery::Page.friendly_id_config.reserved_words |= ::Refinery::Application.routes.named_routes.map { |name, route|
    route.path.gsub(/^\//, '').to_s.split('(').first.to_s.split(':').first.to_s.split('/')
  }.flatten.reject{|w| w =~ /\_/}.uniq
end
