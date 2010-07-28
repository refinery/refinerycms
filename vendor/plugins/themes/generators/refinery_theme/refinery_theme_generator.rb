class RefineryThemeGenerator < Rails::Generator::Base

  def manifest
    unless @args[0].nil?
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
      
        puts 'NOTE: If you want this new theme to be the current theme used, set the "theme"
              setting in the Refinery backend to the name of this theme.'
      end
    else
      puts "You must specify a theme name."
      puts "Eg: ruby script/generate refinery_theme modern"
    end
  end

  def theme_name
    @args[0]
  end
  
end