class RefineryThemeGenerator < Rails::Generator::Base

  def banner
    "Usage: ruby script/generate refinery_theme theme_name"
  end

  def manifest
    if @args[0].nil?
      puts "You must specify a theme name."
      puts banner
      exit
    end

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

      m.directory "themes/#{theme_name}/views/shared"
      ["content_page", "footer", "head", "header", "menu", "menu_branch"].each do |partial|
        m.file "../../../../refinery/app/views/shared/_#{partial}.html.erb","themes/#{theme_name}/views/shared/_#{partial}.html.erb"
      end

      puts 'NOTE: If you want this new theme to be the current theme used, set the "theme"
            setting in the Refinery backend to the name of this theme.' unless RAILS_ENV == "test"
    end
  end

  def theme_name
    @args[0]
  end

end
