class ThemeGenerator < Rails::Generator::Base
  default_options :haml => false

  def manifest
    record do |m|
      m.directory "themes"
      m.directory "themes/#{theme_name}"
      m.directory "themes/#{theme_name}/stylesheets"
      m.directory "themes/#{theme_name}/javascripts"
      m.file "stylesheets/application.css", "themes/#{theme_name}/stylesheets/application.css"
      m.directory "themes/#{theme_name}/views"
      m.directory "themes/#{theme_name}/views/layouts"
      m.file "views/layouts/application.html.erb", "themes/#{theme_name}/views/layouts/application.html.erb"
      m.directory "themes/#{theme_name}/views/pages"
      m.file "views/pages/index.html.erb", "themes/#{theme_name}/views/pages/index.html.erb"
      m.file "views/pages/index.html.erb", "themes/#{theme_name}/views/pages/show.html.erb"
      m.file 'LICENSE', "themes/#{theme_name}/LICENSE"
      m.file 'README', "themes/#{theme_name}/README"
    end
  end

  def theme_name
    @args[0]
  end
end
