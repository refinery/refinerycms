plugin = Refinery::Plugin.new
plugin.directory = directory
plugin.title = "Refinery"
plugin.description = "Core refinery plugin"
plugin.version = 1.0
plugin.hide_from_menu = true

require_dependency 'refinery/form_helpers'