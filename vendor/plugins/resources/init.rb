plugin = Refinery::Plugin.new
plugin.directory = directory
plugin.title = "Resources"
plugin.description = "Upload and link to files"
plugin.version = 1.0
plugin.activity = {:class => Resource, :title => 'title', :url_prefix => 'edit', :created_image => "page_white_put.png", :updated_image => "page_white_edit.png"}