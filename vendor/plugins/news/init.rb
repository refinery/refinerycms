plugin = Refinery::Plugin.new
plugin.directory = directory
plugin.title = "News"
plugin.description = "Provides a blog-like news section"
plugin.version = 1.0
plugin.activity = {:class => NewsItem, :title => 'title', :url_prefix => 'edit'}