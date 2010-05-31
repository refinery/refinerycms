Refinery::Plugin.register do |plugin|
  plugin.title = "Dialogs"
  plugin.description = "Refinery Dialogs plugin"
  plugin.version = 1.0
  plugin.hide_from_menu = true
  plugin.always_allow_access = true
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
