Refinery::Plugin.register do |plugin|
  plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
  plugin.activity = {
    :class => <%= class_name %><% if attributes.first.name != "title" %>,
    :title => '<%= attributes.first.name %>'
  <% end %>}

  plugin.directory = directory # tell refinery where this plugin is located
end