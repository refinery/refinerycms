namespace :refinery do

  desc "Prepare a basic environment with blank directories ready to override core files safely."
  task :override => :environment do
    dirs = ["app", "app/views", "app/views/layouts", "app/views/admin", "app/views/shared", "app/controllers", "app/models", "app/controllers/admin", "app/helpers", "app/helpers/admin"]
		dirs.each do |dir|
			dir = Rails.root.join(dir.split('/').join(File::SEPARATOR))
			dir.mkdir unless dir.directory?
		end
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
    require 'pathname'
    require 'fileutils'
    unless Rails.root.nil? or Rails.root.length == 0
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
        match = line.scan(/(:secret)([^']*)([\'])([^\']*)/).flatten.last
        secret_key = match unless match.nil?
        old_refinery_version = line.scan(/(REFINERY_GEM_VERSION)([^']*)([\'])([^\']*)/).flatten.last
      end

	    # read in the config files
	    if File.exist?(File.join(%W(#{Rails.root} config application.rb)))
	      FileUtils::cp File.join(%W(#{Refinery.root} config environment.rb)), File.join(%W(#{Rails.root} config environment.rb))
      else
        # write the new content into the file.
        FileUtils::cp File.join(%W(#{Refinery.root} config application.rb)), File.join(%W(#{Rails.root} config application.rb))

        app_rb_lines = File.open(File.join(%W(#{Rails.root} config application.rb)), "r").read.split("\n")
        app_rb_lines.each do |line|
          match = line.scan(/(:secret)([^']*)([\'])([^\']*)/).flatten.last
          line.gsub!(match, secret_key) unless match.nil?
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

      # backup app's config file and replace it, if required.
	    environment_updated = false
      matcher = /(#===REFINERY REQUIRED GEMS===)(.+?)(#===REFINERY END OF REQUIRED GEMS===)/m
      
      # backup the config file.
    	FileUtils.cp File.join(%W(#{Rails.root} config #{app_config_file})), File.join(%W(#{Rails.root} config #{app_config_file.gsub(".rb", "")}.autobackupbyrefinery.rb))

      # copy the new config file.
      FileUtils.cp File.join(%W(#{Refinery.root} config #{app_config_file})), File.join(%W(#{Rails.root} config #{app_config_file}))

    	environment_updated = true

	    unless ARGV.include?("--from-refinery-installer")
	      puts "---------"
	      puts "Copied new Refinery core assets."
	      if environment_updated
      	  puts "I've made a backup of your current config/#{app_config_file} file as it has been updated with the latest Refinery requirements."
      	  puts "The backup is located at config/#{app_config_file.gsub(".rb", "")}.autobackupbyrefinery.rb incase you need it."
        end
	      puts ""
	      puts "=== ACTION REQUIRED ==="
	      puts "Please run rake db:migrate to ensure your database is at the correct version."
	      puts "Please also run rake gems:install to ensure you have the currently specified gems." if environment_updated

	      puts ""
      end
    else
      unless ARGV.include?("--from-refinery-installer")
        puts "Please specify the path of the refinery project that you want to update, i.e. refinery-update-core /path/to/project"
      end
    end
  end
  
  namespace :override do
    
  end
  
  namespace :cache do
    desc "Eliminate existing cache files for javascript and stylesheet resources in default directories"
    task :clear => :environment do
      FileUtils.rm(Dir[Rails.root.join("public", "javascripts", "cache", "[^.]*")])
      FileUtils.rm(Dir[Rails.root.join("public", "stylesheets", "cache", "[^.]*")])
    end
  end

end

