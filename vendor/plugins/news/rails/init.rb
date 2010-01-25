Refinery::Plugin.register do |plugin|
  plugin.title = "News"
  plugin.name = "refinery_news"
  plugin.directory = "news"
  plugin.description = "Provides a blog-like news section"
  plugin.version = 1.0
  plugin.menu_match = /admin\/((news)|(news_items))$/
  plugin.activity = {:class => NewsItem, :title => 'title', :url_prefix => 'edit'}
end
