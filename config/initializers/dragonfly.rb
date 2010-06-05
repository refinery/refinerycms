require 'dragonfly'

app1 = Dragonfly::App[:images]
# app1.configure_with(Dragonfly::Config::HerokuRailsImages, 'my_bucket_name')
app1.configure_with(Dragonfly::Config::RailsImages) do |c|
  c.datastore.root_path = "#{::Rails.root}/public/system/images"
  c.url_handler.path_prefix = '/assets/images'
  c.url_handler.secret      = 'bawyuebIkEasjibHavry'
end

app2 = Dragonfly::App[:resources]
app2.configure_with(Dragonfly::Config::RailsDefaults) do |c|
  c.register_analyser(Dragonfly::Analysis::FileCommandAnalyser)
  c.register_encoder(Dragonfly::Encoding::TransparentEncoder)
  c.datastore.root_path = "#{::Rails.root}/public/system/resources"
  c.url_handler.path_prefix = '/assets/files'
  c.url_handler.secret      = 'SweinkelvyonCaccepla'
end

Dragonfly.active_record_macro(:image,    app1)
Dragonfly.active_record_macro(:resource, app2)
