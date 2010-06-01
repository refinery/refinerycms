Refinery::Plugin.register do |plugin|
  plugin.title = "Inquiries"
  plugin.name = "refinery_inquiries"
  plugin.directory = "inquiries"
  plugin.description = "Provides a contact form and stores inquiries"
  plugin.version = 1.0
  plugin.menu_match = /(refinery|admin)\/inquir(ies|y_settings)$/
  plugin.activity = [
    {:class => InquirySetting, :url_prefix => "edit", :title => 'name', :url_prefix => 'edit'}
  ]
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
