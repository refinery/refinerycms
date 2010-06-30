Refinery::Plugin.register do |plugin|
  plugin.title = "Dashboard"
  plugin.name = "refinery_dashboard"
  plugin.menu_match = /(admin|refinery)\/(refinery_)?dashboard$/
  plugin.description = "Gives an overview of activity in Refinery"
  plugin.directory = "dashboard"
  plugin.version = 1.0
  plugin.always_allow_access = true
  plugin.dashboard = true
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
