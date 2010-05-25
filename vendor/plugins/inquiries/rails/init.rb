Refinery::Plugin.register do |plugin|
  plugin.title = "Inquiries"
  plugin.description = "Provides a contact form and stores inquiries"
  plugin.version = 1.0
  plugin.menu_match = /admin\/inquir(ies|y_settings)$/
  plugin.activity = [
    {:class => InquirySetting, :url_prefix => "edit", :title => 'name', :url_prefix => 'edit'}
  ]
end
