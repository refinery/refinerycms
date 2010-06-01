Refinery::Plugin.register do |plugin|
  plugin.title = "Images"
  plugin.name = "refinery_images"
  plugin.directory = "images"
  plugin.description = "Manage images"
  plugin.version = 1.0
  plugin.menu_match = /(refinery|admin)\/image(_dialog)?s$/
  plugin.activity = {
    :class => Image,
    :title => 'title',
    :url_prefix => 'edit',
    :conditions => "parent_id IS NULL",
    :created_image => "image_add.png",
    :updated_image => "image_edit.png"
  }
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  plugin.directory = directory
end
