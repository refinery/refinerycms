Refinery::Plugin.register do |plugin|
  plugin.title = "Pages"
  plugin.name = "refinery_pages"
  plugin.directory = "pages"
  plugin.description = "Manage content pages"
  plugin.version = 1.0
  plugin.menu_match = /admin\/page(_dialog|_part)?s$/
  plugin.activity = {
    :class => Page,
    :url_prefix => "edit",
    :title => "title",
    :created_image => "page_add.png",
    :updated_image => "page_edit.png"
  }
end
