Refinery::Plugin.register do |plugin|
  plugin.title = "Dashboard"
  plugin.description = "Gives an overview of activity in Refinery"
  plugin.version = 1.0
  plugin.always_allow_access = true
  plugin.directory = directory # this tells refinery where this plugin is located on the filesystem.
end
