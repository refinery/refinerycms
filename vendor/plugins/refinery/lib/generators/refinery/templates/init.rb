Refinery::Plugin.register do |plugin|
  plugin.directory = directory
  plugin.title = "<%= class_name.pluralize.underscore.titleize %>"
  plugin.description = "Manage <%= class_name.pluralize.underscore.titleize %>"
  plugin.version = 1.0
  plugin.activity = {:class => <%= class_name %>, :url_prefix => "edit_", :title => '<%= attributes.first.name %>'}
end
