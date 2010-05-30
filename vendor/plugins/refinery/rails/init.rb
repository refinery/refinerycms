Refinery::Plugin.register do |plugin|
  plugin.title = "Refinery"
  plugin.description = "Core refinery plugin"
  plugin.version = 1.0
  plugin.hide_from_menu = true
  plugin.always_allow_access = true
  plugin.menu_match = /admin\/(refinery_core|base)$/
  plugin.directory = directory # this tells refinery where this plugin is located on the filesystem.
end
require_dependency 'refinery/form_helpers'
require_dependency 'refinery/base_presenter'

[ Refinery.root.join("vendor", "plugins", "*", "app", "presenters").to_s,
  Rails.root.join("vendor", "plugins", "*", "app", "presenters").to_s,
  Rails.root.join("app", "presenters").to_s
].uniq.each do |path|
  Dir[path].each do |presenters_path|
    $LOAD_PATH << presenters_path
    ::ActiveSupport::Dependencies.load_paths << presenters_path
  end
end
