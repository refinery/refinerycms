Refinery::Plugin.register do |plugin|
  plugin.title = "Themes"
  plugin.description = "Upload and manage themes"
  plugin.version = 1.0
  plugin.activity = {
    :class => Theme,
    :title => 'title',
    :url_prefix => 'edit',
    :created_image => "layout_add.png",
    :updated_image => "layout_edit.png"
  }
end
