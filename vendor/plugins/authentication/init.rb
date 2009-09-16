Refinery::Plugin.register do |plugin|
  plugin.title = "Users"
  plugin.description = "Manage users"
  plugin.version = 1.0
  plugin.menu_match = /admin\/(users)/
  plugin.activity = {
    :class => User, 
    :url_prefix => "edit_", 
    :title => "title", 
    :created_image => "page_add.png", 
    :updated_image => "page_edit.png"
  }
end