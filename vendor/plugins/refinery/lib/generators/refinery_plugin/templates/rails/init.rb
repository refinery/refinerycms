Refinery::Plugin.register do |plugin|
  plugin.name = "<%= class_name.pluralize.underscore.downcase %>"
  plugin.activity = {
    :class => <%= class_name %><% if attributes.first.name != "title" %>,
    :title => '<%= attributes.select { |a| a.type.to_s == "string" }.first.name %>'
  <% end %>}

  plugin.directory = directory # tell refinery where this plugin is located
end
