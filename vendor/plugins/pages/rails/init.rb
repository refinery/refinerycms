Refinery::Plugin.register do |plugin|
  plugin.title = "Pages"
  plugin.name = "refinery_pages"
  plugin.directory = "pages"
  plugin.description = "Manage content pages"
  plugin.version = 1.0
  plugin.menu_match = /(refinery|admin)\/page(_part)?s(_dialogs)?$/
  plugin.activity = {
    :class => Page,
    :url_prefix => "edit",
    :title => "title",
    :created_image => "page_add.png",
    :updated_image => "page_edit.png"
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
