Refinery::Plugin.register do |plugin|
  plugin.title = "Settings"
  plugin.name = "refinery_settings"
  plugin.url = {:controller => "/refinery/settings"}
  plugin.description = "Manage Refinery settings"
  plugin.version = 1.0
  plugin.menu_match = /(refinery|admin)\/(refinery_)?settings$/
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
