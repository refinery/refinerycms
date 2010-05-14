Refinery::Plugin.register do |plugin|
  plugin.title = "Settings"
  plugin.description = "Manage Refinery settings"
  plugin.version = 1.0
  plugin.menu_match = /admin\/(refinery_)?settings$/
end
