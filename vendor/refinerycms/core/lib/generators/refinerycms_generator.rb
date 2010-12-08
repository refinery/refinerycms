require 'fileutils'

class RefinerycmsGenerator < ::Refinery::Generators::EngineInstaller

  engine_name :refinerycms
  source_root Refinery.root

  def generate
    # First, rename files that get in the way of Refinery CMS
    %w(public/index.html app/views/layouts/application.html.erb db/seeds.rb).each do |roadblock|
      if (roadblock = Rails.root.join(roadblock)).file?
        rename_to = roadblock.to_s.gsub(roadblock.split.last.to_s, "your_#{roadblock.split.last}")
        FileUtils::mv roadblock, rename_to
        puts "Renamed #{roadblock.to_s.split("#{Rails.root}/").last} to #{rename_to.to_s.split("#{Rails.root}/").last}"
      end
    end

    # Overwrite rails defaults with refinery defaults
    %w(features spec).each do |folder|
      FileUtils::cp_r Refinery.root.join(folder), Rails.root, :verbose => true
    end

    # Copy in important files to the Rails app.
    %w(.rspec config/cucumber.yml).each do |file|
      # Backup their version if it exists
      if Rails.root.join(file).file? and !(backup = Rails.root.join(file)).file?
        (backup = Rails.root.join(file).split('/'))[-1] = "your_#{backup.last}"
        FileUtils::mv Rails.root.join(file), backup.to_s, :verbose => true
      end

      FileUtils::cp Refinery.root.join(file), Rails.root.join(file),
                    :verbose => true if Refinery.root.join(file).exist?
    end

    # Copy the 'client app version' of the admin javascript file, unless it exists.
    if (admin_js = Refinery.root.join('vendor', 'refinerycms', 'core', 'public', 'javascripts', 'admin.js')).file?
      FileUtils::cp admin_js,
                    Rails.root.join('public', 'javascripts').to_s,
                    :verbose => true unless Rails.root.join('public', 'javascripts', 'admin.js').file?
    end

    # Copy stylesheets so they're ready to use, unless they exist.
    %w(application.css formatting.css home.css theme.css).map{ |ss|
      Refinery.root.join('vendor', 'refinerycms', 'core', 'public', 'stylesheets', ss)
    }.reject{|ss| !ss.file? or Rails.root.join('public', 'stylesheets', ss.split.last).file?}.each do |stylesheet|
      FileUtils::cp stylesheet, Rails.root.join('public', 'stylesheets').to_s,
                    :verbose => true
    end

    # Ensure the config.serve_static_assets setting is present and enabled
    %w(development test production).map{|e| "config/environments/#{e}.rb"}.each do |env|
      contents = Rails.root.join(env).read
      contents.gsub! %r{#.*config.serve_static_assets}, 'config.serve_static_assets'
      contents.gsub! "serve_static_assets = false", "serve_static_assets = true # Refinery CMS requires this to be true"
      contents << "\n\nRefinery.rescue_not_found = #{env.split('/').last.split('.rb').first == 'production'}"
      Rails.root.join(env).open("w").puts(contents)
    end

    # Ensure that our tasks can be run from the client application
    unless (rakefile = Rails.root.join("Rakefile")).read.include?('Refinery::Application.load_tasks')
      rakefile.open("a+").puts('Refinery::Application.load_tasks')
    end

    # Ensure .gitignore exists and append our stuff to it.
    FileUtils::touch(gitignore = Rails.root.join('.gitignore'))
    gitignore.open('a+').puts Refinery.root.join('.gitignore').read.split('# REFINERY CMS DEVELOPMENT').first

    super
  end

end
