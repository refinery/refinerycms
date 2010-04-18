Refinery::Plugin.register do |plugin|
  plugin.name = "refinery_dashboard"
  plugin.title = "Dashboard"
  plugin.description = "Gives an overview of activity in Refinery"
  plugin.directory = "dashboard"
  #TODO Find out why the menu_match is necessary; does the magic magic in Refinery::Plugin fail?
  plugin.menu_match = /admin\/dashboard/
  plugin.version = 1.0
  plugin.always_allow_access = true
end
