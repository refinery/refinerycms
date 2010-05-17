namespace :refinery do

  desc "Override files for use in an application"
  task :override => :environment do
    require 'fileutils'

    if defined?(THEME)
      # Prepare the basic structure for the theme directory
      dirs = ["themes", "themes/#{THEME}", "themes/#{THEME}/views", "themes/#{THEME}/views/layouts", "themes/#{THEME}/views/shared", "themes/#{THEME}/views/pages", "themes/#{THEME}/stylesheets", "themes/#{THEME}/javascripts", "themes/#{THEME}/images"]
		  dirs.each do |dir|
			  dir = Rails.root.join(dir.split('/').join(File::SEPARATOR))
			  dir.mkdir unless dir.directory?
		  end
		else
		  # Prepare the basic structure for the app directory
      dirs = ["app", "app/views", "app/views/layouts", "app/views/admin", "app/views/shared", "app/controllers", "app/models", "app/controllers/admin", "app/helpers", "app/helpers/admin"]
		  dirs.each do |dir|
			  dir = Rails.root.join(dir.split('/').join(File::SEPARATOR))
			  dir.mkdir unless dir.directory?
		  end
		end

    if defined?(VIEW) || defined?(CONTROLLER) || defined?(MODEL)
    end

=begin
      # copy the controller
      unless controller_with_admin =~ /\*(\*)?/ and !action.nil?
        refinery_controllers = Dir[refinery_root.join("vendor", "plugins", "**", "app", "controllers", "#{controller_with_admin}_controller.rb")].compact
        if refinery_controllers.any? # the controllers may not exist.
          refinery_controllers.each do |refinery_controller|
            # make the directories
            FileUtils.mkdir_p(copy_to = rails_root.join("app", "controllers", admin).to_s)
            FileUtils.cp(refinery_controller, copy_to)
          end
        else
          puts "Note: Couldn't find a matching controller to override."
        end
      end

      # copy the action, if it exists
      unless action.nil? or action.length == 0
        # get all the matching files
        looking_for = refinery_root.join("vendor", "plugins", "**", "app", "views", controller_with_admin.split("/").join(File::SEPARATOR), "#{action}*.erb")
        action_files = Dir[looking_for]

        # copy in the action template
        action_files.each do |action_file|
          action_file_path = action_file.split("/app/views/").last
          action_file_dir = action_file_path.split('/')
          action_file_dir.pop # get rid of the file.

          FileUtils.mkdir_p(rails_root.join("app", "views", action_file_dir.join(File::SEPARATOR)))
          FileUtils.cp action_file, rails_root.join("app", "views", action_file_path)
        end
      else
        puts "Note: No action was specified."
      end
    else
      puts "You didn't specify anything to override. Here's some examples:"
      puts "refinery-override /pages/* /path/to/my/project"
      puts "refinery-override /pages/show /path/to/my/project"
      puts "refinery-override /admin/pages/index"
      puts "refinery-override /shared/_menu /path/to/my/project"
      puts "refinery-override **/*menu /path/to/my/project"
      puts "refinery-override /shared/_menu_branch"
    end
=end

  end

  desc "Required to upgrade from <= 0.9.0 to 0.9.1 and above"
  task :fix_image_paths_in_content => :environment do
    Page.all.each do |p|
      p.parts.each do |pp|
        pp.update_attribute(:body, pp.body.gsub(/\/images\/system\//, "/system/images/"))
      end
    end

    NewsItem.all.each do |ni|
      ni.update_attribute(:body, ni.body.gsub(/\/images\/system\//, "/system/images/"))
    end

  end

  desc "Update the core files with the gem"
  task :update => :environment do
    require 'fileutils'

    # ensure asset directories exist.
    dirs = [%w(public stylesheets), %w(public javascripts), %w(db migrate)]
    FileUtils::makedirs dirs.map {|dir| File.join(Rails.root, dir) }

    # copy in the new assets.
    assets = [%w(public stylesheets refinery), %w(public javascripts refinery), %w(public javascripts wymeditor), %w(VERSION), %w(public images wymeditor skins refinery), %w(public images refinery), %w(public stylesheets wymeditor skins refinery), %w(public javascripts jquery)]
    assets.each do |asset|
      FileUtils::rm_rf File.join(Rails.root, asset), :secure => true # ensure the destination is clear.
      FileUtils::cp_r File.join(Refinery.root, asset), File.join(Rails.root, asset) # copy the new assets into the project.
    end

    # copy in any new migrations.
    FileUtils::cp Dir[Refinery.root.join("db", "migrate", "*.rb").cleanpath.to_s], Rails.root.join("db", "migrate").cleanpath.to_s

    # replace rakefile and gemfile.
    FileUtils::cp Refinery.root.join("Rakefile").cleanpath.to_s, Rails.root.join("Rakefile").cleanpath.to_s
    unless Rails.root.join("Gemfile").exist?
      FileUtils::cp Refinery.root.join("Gemfile").cleanpath.to_s, Rails.root.join("Gemfile").cleanpath.to_s
    else
      # TODO only override refinery gems here.
    end

    # replace the preinitializer.
    FileUtils::cp Refinery.root.join("config", "preinitializer.rb").cleanpath.to_s, Rails.root.join("config", "preinitializer.rb").cleanpath.to_s

    # copy the lib/refinery directory in
    FileUtils::cp_r Refinery.root.join("lib", "refinery").cleanpath.to_s, Rails.root.join("lib").cleanpath.to_s

    # get current secret key
    unless Rails.root.join("config", "application.rb").exist?
      lines = Rails.root.join("config", "environment.rb").read.split("\n")
    else
      lines = Rails.root.join("config", "application.rb").read.split("\n")
    end

    secret_key = ""
    lines.each do |line|
      secret_match = line.scan(/(:secret)([^']*)([\'])([^\']*)/).flatten.last
      secret_key = secret_match unless secret_match.nil?
      version_match = line.scan(/(REFINERY_GEM_VERSION)([^']*)([\'])([^\']*)/).flatten.last
      old_version = version_match unless version_match.nil?
    end

    # read in the config files
    if Rails.root.join("config", "application.rb").exist?
      FileUtils::cp Refinery.root.join("config", "environment.rb").cleanpath.to_s, Rails.root.join("config", "environment.rb").cleanpath.to_s
    else
      # write the new content into the file.
      FileUtils::cp Refinery.root.join("config", "application.rb").cleanpath.to_s, Rails.root.join("config", "application.rb").cleanpath.to_s

      (app_rb_lines = Rails.root.join("config", "application.rb").read.split('\n')).each do |line|
        secret_match = line.scan(/(:secret)([^']*)([\'])([^\']*)/).flatten.last
        line.gsub!(secret_match, secret_key) unless secret_match.nil?
      end

      # write the new content into the file.
      Rails.root.join("config", "application.rb").open("w").puts(app_rb_lines.join('\n'))

      FileUtils::cp Refinery.root.join('config', 'environment.rb').cleanpath.to_s, Rails.root.join('config', 'environment.rb').cleanpath.to_s
    end

    unless Rails.root.join("config", "settings.rb").exist?
      FileUtils::cp(Refinery.root.join('config', 'settings.rb').cleanpath.to_s, Rails.root.join('config', 'settings.rb').cleanpath.to_s)
    end

    app_config_file = "application.rb"

    app_config = Rails.root.join("config", app_config_file).read

    # copy new jquery javascripts.
    FileUtils.cp Refinery.root.join('public', 'javascripts', 'jquery.js').cleanpath.to_s, Rails.root.join('public', 'javascripts', 'jquery.js').cleanpath.to_s
    FileUtils.cp Refinery.root.join('public', 'javascripts', 'jquery-ui.js').cleanpath.to_s, Rails.root.join('public', 'javascripts', 'jquery-ui.js').cleanpath.to_s

    # backup the config file.
    FileUtils.cp Rails.root.join('config', app_config_file).cleanpath.to_s, Rails.root.join('config', "#{app_config_file.gsub('.rb', '')}.autobackup.rb").cleanpath.to_s

    # copy the new config file.
    FileUtils.cp Refinery.root.join('config', app_config_file).cleanpath.to_s, Rails.root.join('config', app_config_file).cleanpath.to_s

    unless (ENV["from_installer"] || 'false').to_s == 'true'
      puts "---------"
      puts "Copied new Refinery core assets."
      puts "I've made a backup of your current config/#{app_config_file} file as it has been updated with the latest Refinery requirements."
      puts "The backup is located at config/#{app_config_file.gsub(".rb", "")}.autobackupbyrefinery.rb incase you need it."
      puts ""
      puts "=== ACTION REQUIRED ==="
      puts "Please run rake db:migrate to ensure your database is at the correct version."
      puts "Please also run bundle install to ensure you have the currently specified gems."
      puts ""
    end
  end

  namespace :cache do
    desc "Eliminate existing cache files for javascript and stylesheet resources in default directories"
    task :clear => :environment do
      FileUtils.rm(Dir[Rails.root.join("public", "javascripts", "cache", "[^.]*").cleanpath.to_s])
      FileUtils.rm(Dir[Rails.root.join("public", "stylesheets", "cache", "[^.]*").cleanpath.to_s])
    end
  end

end

