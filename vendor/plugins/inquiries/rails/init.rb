Refinery::Plugin.register do |plugin|
  plugin.title = "Inquiries"
  plugin.description = "Provides a contact form and stores inquiries"
  plugin.version = 1.0
  plugin.menu_match = /admin\/inquir(ies|y_settings)$/
  plugin.activity = [
    {:class => Inquiry, :title => "name", :url_prefix => "", :created_image => "email_open.png", :updated_image => "email_edit.png"},
  ]
end
