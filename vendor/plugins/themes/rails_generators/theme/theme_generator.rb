class ThemeGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory "themes"
      m.directory "themes/#{theme_name}"
      m.directory "themes/#{theme_name}/javascripts"
      
      m.directory "themes/#{theme_name}/stylesheets"
      m.file "stylesheets/application.css", "themes/#{theme_name}/stylesheets/application.css"
      m.file "stylesheets/formatting.css", "themes/#{theme_name}/stylesheets/formatting.css"
      m.file "stylesheets/home.css", "themes/#{theme_name}/stylesheets/home.css"

      m.directory "themes/#{theme_name}/views"
      m.directory "themes/#{theme_name}/views/layouts"
      m.file "views/layouts/application.html.erb", "themes/#{theme_name}/views/layouts/application.html.erb"
      
      m.directory "themes/#{theme_name}/views/pages"
      m.file "views/pages/show.html.erb", "themes/#{theme_name}/views/pages/show.html.erb"
      m.file "views/pages/home.html.erb", "themes/#{theme_name}/views/pages/home.html.erb"
    end
  end

  def theme_name
    @args[0]
  end
  
end