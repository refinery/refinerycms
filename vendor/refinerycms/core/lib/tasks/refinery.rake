namespace :refinery do

  desc "Override files for use in an application"
  task :override => :environment do
    require 'fileutils'

    if (view = ENV["view"]).present?
      pattern = "#{view.split("/").join(File::SEPARATOR)}*.erb"
      looking_for = Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "views", pattern).to_s}

      # copy in the matches
      matches = looking_for.collect{|d| Dir[d]}.flatten.compact.uniq
      if matches.any?
        matches.each do |match|
          dir = match.split("/app/views/").last.split('/')
          file = dir.pop # get rid of the file.
          dir = dir.join(File::SEPARATOR) # join directory back together

          unless (theme = ENV["theme"]).present?
            destination_dir = Rails.root.join("app", "views", dir)
          else
            destination_dir = Rails.root.join("themes", theme, "views", dir)
          end
          FileUtils.mkdir_p(destination_dir)
          FileUtils.cp match, (destination = File.join(destination_dir, file))

          puts "Copied view template file to #{destination.gsub("#{Rails.root.to_s}#{File::SEPARATOR}", '')}"
        end
      else
        puts "Couldn't match any view template files in any engines like #{view}"
      end
    elsif (controller = ENV["controller"]).present?
      pattern = "#{controller.split("/").join(File::SEPARATOR)}*.rb"
      looking_for = Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "controllers", pattern).to_s}

      # copy in the matches
      matches = looking_for.collect{|d| Dir[d]}.flatten.compact.uniq
      if matches.any?
        matches.each do |match|
          dir = match.split("/app/controllers/").last.split('/')
          file = dir.pop # get rid of the file.
          dir = dir.join(File::SEPARATOR) # join directory back together

          destination_dir = Rails.root.join("app", "controllers", dir)
          FileUtils.mkdir_p(destination_dir)
          FileUtils.cp match, (destination = File.join(destination_dir, file))

          puts "Copied controller file to #{destination.gsub("#{Rails.root.to_s}#{File::SEPARATOR}", '')}"
        end
      else
        puts "Couldn't match any controller files in any engines like #{controller}"
      end
    elsif (model = ENV["model"]).present?
      pattern = "#{model.split("/").join(File::SEPARATOR)}*.rb"
      looking_for = Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "models", pattern).to_s}

      # copy in the matches
      matches = looking_for.collect{|d| Dir[d]}.flatten.compact.uniq
      if matches.any?
        matches.each do |match|
          dir = match.split("/app/models/").last.split('/')
          file = dir.pop # get rid of the file.
          dir = dir.join(File::SEPARATOR) # join directory back together

          destination_dir = Rails.root.join("app", "models", dir)
          FileUtils.mkdir_p(destination_dir)
          FileUtils.cp match, (destination = File.join(destination_dir, file))

          puts "Copied model file to #{destination.gsub("#{Rails.root.to_s}#{File::SEPARATOR}", '')}"
        end
      else
        puts "Couldn't match any model files in any engines like #{model}"
      end
    else
      puts "You didn't specify anything to override. Here's some examples:"
      puts "rake refinery:override view=pages/home"
      puts "rake refinery:override controller=pages"
      puts "rake refinery:override model=page"
      puts "rake refinery:override view=pages/home theme=demolicious"
      puts "rake refinery:override **/*menu"
      puts "rake refinery:override shared/_menu_branch"
    end
  end

  desc "Update the core files with the gem"
  task :update => :environment do
    verbose = ENV["verbose"] || false
    require 'fileutils'

    # copy in any new migrations.
    FileUtils::cp Dir[Refinery.root.join("db", "migrate", "*.rb").cleanpath.to_s],
                  Rails.root.join("db", "migrate").cleanpath.to_s,
                  :verbose => verbose

    # replace rakefile and gemfile.
    FileUtils::cp Refinery.root.join("Rakefile").cleanpath.to_s,
                  Rails.root.join("Rakefile").cleanpath.to_s,
                  :verbose => verbose

    unless Rails.root.join("Gemfile").exist?
      FileUtils::cp Refinery.root.join("Gemfile").cleanpath.to_s,
                    Rails.root.join("Gemfile").cleanpath.to_s,
                    :verbose => verbose
    else
      # replace refinery's gem requirements in the Gemfile
      refinery_gem_requirements = Refinery.root.join('Gemfile').read.to_s.scan(
        /(#===REFINERY REQUIRED GEMS===.+?#===REFINERY END OF REQUIRED GEMS===)/m
      ).first.join('\n')

      rails_gemfile_contents = Rails.root.join("Gemfile").read.to_s.gsub(
        /(#===REFINERY REQUIRED GEMS===.+?#===REFINERY END OF REQUIRED GEMS===)/m,
        refinery_gem_requirements
      )

      Rails.root.join("Gemfile").open('w+') do |f|
        f.write(rails_gemfile_contents)
      end
    end

    # add the cucumber environment file if it's not present
    unless (cucumber_environment_file = Rails.root.join('config', 'environments', 'cucumber.rb')).exist?
      FileUtils::cp Refinery.root.join('config', 'environments', 'cucumber.rb').to_s,
                    cucumber_environment_file.to_s,
                    :verbose => verbose

      # Add cucumber database adapter (link to test)
      existing_db_config = Rails.root.join('config', 'database.yml').read.to_s
      Rails.root.join('config', 'database.yml').open('w+') do |f|
        f.write "#{existing_db_config.gsub("test:\n", "test: &test\n")}\n\ncucumber:\n  <<: *test"
      end
    end

    unless Rails.root.join("config", "settings.rb").exist?
      FileUtils::cp Refinery.root.join('config', 'settings.rb').cleanpath.to_s,
                    Rails.root.join('config', 'settings.rb').cleanpath.to_s,
                    :verbose => verbose
    end

    puts "\n" if verbose

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

namespace :test do
  desc "Run the tests that ship with Refinery to ensure any changes you've made haven't caused instability."
  task :refinery do
    errors = %w(spec cucumber).collect do |task|
      begin
        Rake::Task[task].invoke
        nil
      rescue => e
        task
      end
    end.compact
    abort "Errors running #{errors.to_sentence(:locale => :en)}!" if errors.any?
  end
end

desc 'Removes trailing whitespace across the entire application.'
task :whitespace do
  if RUBY_PLATFORM =~ /linux/
    sh %{find . -name '*.*rb' -exec sed -i 's/\t/  /g' {} \\; -exec sed -i 's/ *$//g' {} \\; }
  elsif RUBY_PLATFORM =~ /darwin/
    sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/  /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
  else
    puts "This doesn't work on systems other than OSX or Linux. Please use a custom whitespace tool for your platform '#{RUBY_PLATFORM}'."
  end
end