Refinery::Plugin.register do |plugin|
  plugin.title = "Files"
  plugin.name = "refinery_files"
  plugin.menu_match = /(refinery|admin)\/(refinery_)?(files|resources)$/
  plugin.description = "Upload and link to files"
  plugin.version = 1.0
  plugin.activity = {
    :class => Resource,
    :title => 'title',
    :url_prefix => 'edit',
    :created_image => "page_white_put.png",
    :updated_image => "page_white_edit.png"
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
