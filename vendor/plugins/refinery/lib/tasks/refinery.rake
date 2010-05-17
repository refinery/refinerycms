namespace :refinery do

  desc "Override files for use in an application"
  task :override => :environment do
    require 'fileutils'

    if THEME.exist?
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

    if VIEW.exist? || CONTROLLER.exist? || MODEL.exist?

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
    FileUtils::cp Dir[File.join(%W(#{Refinery.root} db migrate *.rb))], File.join(%W(#{Rails.root} db migrate))

    # replace rakefile.
    FileUtils::cp File.join(%W(#{Refinery.root} Rakefile)), File.join(%W(#{Rails.root} Rakefile))

    # replace the preinitializer.
    FileUtils::cp File.join(%W(#{Refinery.root} config preinitializer.rb)), File.join(%W(#{Rails.root} config preinitializer.rb))

    # copy the lib/refinery directory in
    FileUtils::cp_r File.join(%W(#{Refinery.root} lib refinery)), File.join(Rails.root, "lib")

    # get current secret key
    if !File.exist?(File.join(%W(#{Rails.root} config application.rb)))
      lines = File.open(File.join(%W(#{Rails.root} config environment.rb)), "r").read.split("\n")
    else
      lines = File.open(File.join(%W(#{Rails.root} config application.rb)), "r").read.split("\n")
    end

    secret_key = ""
    lines.each do |line|
      secret_match = line.scan(/(:secret)([^']*)([\'])([^\']*)/).flatten.last
      secret_key = secret_match unless secret_match.nil?
      version_match = line.scan(/(REFINERY_GEM_VERSION)([^']*)([\'])([^\']*)/).flatten.last
      old_version = version_match unless version_match.nil?
    end

    # read in the config files
    if File.exist?(File.join(%W(#{Rails.root} config application.rb)))
      FileUtils::cp File.join(%W(#{Refinery.root} config environment.rb)), File.join(%W(#{Rails.root} config environment.rb))
    else
      # write the new content into the file.
      FileUtils::cp File.join(%W(#{Refinery.root} config application.rb)), File.join(%W(#{Rails.root} config application.rb))

      app_rb_lines = File.open(File.join(%W(#{Rails.root} config application.rb)), "r").read.split("\n")
      app_rb_lines.each do |line|
        secret_match = line.scan(/(:secret)([^']*)([\'])([^\']*)/).flatten.last
        line.gsub!(secret_match, secret_key) unless secret_match.nil?
      end

      # write the new content into the file.
      File.open(File.join(%W(#{Rails.root} config application.rb)), "w").puts(app_rb_lines.join("\n"))

      FileUtils::cp File.join(%W(#{Refinery.root} config environment.rb)), File.join(%W(#{Rails.root} config environment.rb))
    end

    unless File.exist?(File.join(%W(#{Rails.root} config settings.rb)))
      FileUtils::cp(File.join(%W(#{Refinery.root} config settings.rb)), File.join(%W(#{Rails.root} config settings.rb)))
    end

    app_config_file = "application.rb"

    app_config = File.open(File.join(%W(#{Rails.root} config #{app_config_file})), "r").read

    # copy new jquery javascripts.
    FileUtils.cp File.join(%W(#{Refinery.root} public javascripts jquery.js)), File.join(%W(#{Rails.root} public javascripts jquery.js))
    FileUtils.cp File.join(%W(#{Refinery.root} public javascripts jquery-ui-1.8.min.js)), File.join(%W(#{Rails.root} public javascripts jquery-ui-1.8.min.js))

    # backup the config file.
    FileUtils.cp File.join(%W(#{Rails.root} config #{app_config_file})), File.join(%W(#{Rails.root} config #{app_config_file.gsub(".rb", "")}.autobackupbyrefinery.rb))

    # copy the new config file.
    FileUtils.cp File.join(%W(#{Refinery.root} config #{app_config_file})), File.join(%W(#{Rails.root} config #{app_config_file}))

    unless ARGV.include?("--from-refinery-installer")
      puts "---------"
      puts "Copied new Refinery core assets."
      puts "I've made a backup of your current config/#{app_config_file} file as it has been updated with the latest Refinery requirements."
      puts "The backup is located at config/#{app_config_file.gsub(".rb", "")}.autobackupbyrefinery.rb incase you need it."
      puts ""
      puts "=== ACTION REQUIRED ==="
      puts "Please run rake db:migrate to ensure your database is at the correct version."
      puts "Please also run rake gems:install to ensure you have the currently specified gems."
      puts ""
    end
  end

  end

  namespace :cache do
    desc "Eliminate existing cache files for javascript and stylesheet resources in default directories"
    task :clear => :environment do
      FileUtils.rm(Dir[Rails.root.join("public", "javascripts", "cache", "[^.]*")])
      FileUtils.rm(Dir[Rails.root.join("public", "stylesheets", "cache", "[^.]*")])
    end
  end

end

