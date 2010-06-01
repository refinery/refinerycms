Refinery::Plugin.register do |plugin|
  plugin.title = "<%= class_name.pluralize.underscore.titleize %>"
  plugin.description = "Manage <%= class_name.pluralize.underscore.titleize %>"
  plugin.version = 1.0
  plugin.activity = {
    :class => <%= class_name %>,
    :url_prefix => "edit",
    :title => '<%= attributes.first.name %>'
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  # plugin.directory = directory
end
