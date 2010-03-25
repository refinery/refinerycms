Refinery::Plugin.register do |plugin|
  plugin.title = "<%= class_name.pluralize.underscore.titleize %>"
  plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
  plugin.description = "Manage <%= class_name.pluralize.underscore.titleize %>"
  plugin.version = 1.0
  plugin.activity = {
    :class => <%= class_name %>,
    :url_prefix => "edit",
    :title => '<%= attributes.first.name %>'
  }
end
