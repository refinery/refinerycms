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
      puts "rake refinery:override view=**/*menu"
      puts "rake refinery:override view=shared/_menu_branch"
    end
  end

  desc "Required to upgrade from <= 0.9.0 to 0.9.1 and above"
  task :fix_image_paths_in_content => :environment do
    Page.all.each do |p|
      p.parts.each do |pp|
        pp.update_attribute(:body,
                            pp.body.gsub(/\/images\/system\//, "/system/images/"))
      end
    end

    NewsItem.all.each do |ni|
      ni.update_attribute(:body,
                          ni.body.gsub(/\/images\/system\//, "/system/images/"))
    end

  end

  desc "Update the core files with the gem"
  task :update => :environment do
    verbose = ENV["verbose"] || false
    require 'fileutils'

    # ensure asset directories exist.
    dirs = [%w(public stylesheets), %w(public javascripts), %w(db migrate)]
    FileUtils::makedirs dirs.map {|dir| File.join(Rails.root, dir) }

    # copy in the new assets.
    assets = [%w(public stylesheets refinery),
              %w(public javascripts refinery),
              %w(public javascripts wymeditor),
              %w(public images wymeditor skins refinery),
              %w(public images refinery),
              %w(public stylesheets wymeditor skins refinery),
              %w(public javascripts jquery),
              %w(.gitignore)]
    assets.each do |asset|
      # ensure the destination is clear.
      FileUtils::rm_rf File.join(Rails.root, asset),
                       :secure => true,
                       :verbose => verbose

      # copy the new assets into the project.
      FileUtils::cp_r File.join(Refinery.root, asset),
                      File.join(Rails.root, asset),
                      :verbose => verbose
    end

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

    # Make cucumber features paths
    Rails.root.join('features', 'refinery').mkpath
    Rails.root.join('features', 'step_definitions', 'refinery').mkpath
    Rails.root.join('features', 'support').mkpath
    Rails.root.join('features', 'uploads').mkpath

    # copy in cucumber features
    FileUtils::cp Dir[Refinery.root.join('features', 'refinery', '*.feature').to_s],
                  Rails.root.join('features', 'refinery').to_s,
                  :verbose => verbose

    FileUtils::cp Dir[Refinery.root.join('features', 'step_definitions', 'refinery', '*.rb').to_s],
                  Rails.root.join('features', 'step_definitions', 'refinery').to_s,
                  :verbose => verbose

    FileUtils::cp Dir[Refinery.root.join('features', 'step_definitions', 'web_steps.rb').to_s],
                  Rails.root.join('features', 'step_definitions').to_s,
                  :verbose => verbose

    FileUtils::cp Dir[Refinery.root.join('features', 'uploads', '*').to_s],
                  Rails.root.join('features', 'uploads').to_s,
                  :verbose => verbose

    FileUtils::cp Dir[Refinery.root.join('features', 'support', '*.rb').to_s],
                  Rails.root.join('features', 'support').to_s,
                  :verbose => verbose

    # update the script directory for any fixes that have happened.
    FileUtils::cp_r Dir[Refinery.root.join('script', '*').to_s],
                    Rails.root.join('script').to_s,
                    :verbose => verbose

    FileUtils::chmod_R 0755, Rails.root.join('script').to_s,
                       :verbose => verbose

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

    # replace the preinitializer.
    FileUtils::cp Refinery.root.join("config", "preinitializer.rb").cleanpath.to_s,
                  Rails.root.join("config", "preinitializer.rb").cleanpath.to_s,
                  :verbose => verbose

    # replace the config.ru file
    FileUtils::cp Refinery.root.join('config.ru').cleanpath.to_s,
                  Rails.root.join('config.ru').cleanpath.to_s,
                  :verbose => verbose

    # destroy any lib/refinery directory that we don't need anymore.
    if Rails.root.join('lib', 'refinery').directory?
      FileUtils::rm_rf Rails.root.join('lib', 'refinery').cleanpath.to_s,
                       :secure => true,
                       :verbose => verbose
    end

    # copy any initializers
    Dir[Refinery.root.join('config', 'initializers', '*.rb').to_s].each do |initializer|
      unless (rails_initializer = Rails.root.join('config', 'initializers', initializer.split(File::SEPARATOR).last)).exist?
        FileUtils::cp initializer, rails_initializer, :verbose => verbose
      end
    end

    unless (aai_config_file = Rails.root.join('config', 'acts_as_indexed_config.rb')).exist?
      FileUtils::cp Refinery.root.join('config', 'acts_as_indexed_config.rb').to_s,
                    aai_config_file.to_s,
                    :verbose => verbose
    end

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
      FileUtils::cp Refinery.root.join("config", "environment.rb").cleanpath.to_s,
                    Rails.root.join("config", "environment.rb").cleanpath.to_s,
                    :verbose => verbose
    else
      # write the new content into the file.
      FileUtils::cp Refinery.root.join("config", "application.rb").cleanpath.to_s,
                    Rails.root.join("config", "application.rb").cleanpath.to_s,
                    :verbose => verbose

      (app_rb_lines = Rails.root.join("config", "application.rb").read.split('\n')).each do |line|
        secret_match = line.scan(/(:secret)([^']*)([\'])([^\']*)/).flatten.last
        line.gsub!(secret_match, secret_key) unless secret_match.nil?
      end

      # write the new content into the file.
      Rails.root.join("config", "application.rb").open("w").puts(app_rb_lines.join('\n'))

      FileUtils::cp Refinery.root.join('config', 'environment.rb').cleanpath.to_s,
                    Rails.root.join('config', 'environment.rb').cleanpath.to_s,
                    :verbose => verbose
    end

    unless Rails.root.join("config", "settings.rb").exist?
      FileUtils::cp Refinery.root.join('config', 'settings.rb').cleanpath.to_s,
                    Rails.root.join('config', 'settings.rb').cleanpath.to_s,
                    :verbose => verbose
    end

    app_config_file = "application.rb"

    app_config = Rails.root.join("config", app_config_file).read

    # copy new jquery javascripts.
    FileUtils.cp Refinery.root.join('public', 'javascripts', 'jquery.js').cleanpath.to_s,
                 Rails.root.join('public', 'javascripts', 'jquery.js').cleanpath.to_s,
                 :verbose => verbose

    FileUtils.cp Refinery.root.join('public', 'javascripts', 'jquery-min.js').cleanpath.to_s,
                 Rails.root.join('public', 'javascripts', 'jquery-min.js').cleanpath.to_s,
                 :verbose => verbose

    FileUtils.cp Refinery.root.join('public', 'javascripts', 'jquery-ui-custom-min.js').cleanpath.to_s,
                 Rails.root.join('public', 'javascripts', 'jquery-ui-custom-min.js').cleanpath.to_s,
                 :verbose => verbose

    # Test the admin file to see if it's old
    if ((admin_js_contents = Rails.root.join('public', 'javascripts', 'admin.js').readlines.join('')) == "if (!wymeditorClassesItems) {\n  var wymeditorClassesItems = [];\n}\n\nwymeditorClassesItems = $.extend([\n    {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}\n ,  {name: 'image-align', rules:['left', 'right'], join: '-'}\n ,  {name: 'font-size', rules:['small', 'normal', 'large'], join: '-'}\n], wymeditorClassesItems);")
      FileUtils.cp Refinery.root.join('public', 'javascripts', 'admin.js'),
                   Rails.root.join('public', 'javascripts', 'admin.js')
    elsif admin_js_contents !~ Regexp.new("var custom_wymeditor_boot_options \\= \\{")
      Rails.root.join('public', 'javascripts', 'admin.js').open('a') do |f|
        f.write "#{Refinery.root.join('public', 'javascripts', 'admin.js').readlines.join()}\n"
      end
    end
    # backup the config file.
    FileUtils.cp Rails.root.join('config', app_config_file).cleanpath.to_s,
                 Rails.root.join('config', "#{app_config_file.gsub('.rb', '')}.autobackupbyrefinery.rb").cleanpath.to_s,
                 :verbose => verbose

    # copy the new config file.
    FileUtils.cp Refinery.root.join('config', app_config_file).cleanpath.to_s,
                 Rails.root.join('config', app_config_file).cleanpath.to_s,
                 :verbose => verbose

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
    errors = %w(test:refinery:units test:refinery:functionals test:refinery:integration test:refinery:benchmark spec cucumber).collect do |task|
      begin
        Rake::Task[task].invoke
        nil
      rescue => e
        task
      end
    end.compact
    abort "Errors running #{errors.to_sentence(:locale => :en)}!" if errors.any?
  end
  namespace :refinery do
    Rake::TestTask.new(:units => 'db:test:prepare') do |t|
      t.libs << Refinery.root.join('test').to_s
      t.libs += Dir[Rails.root.join('vendor', 'plugins', '**', 'test').to_s].flatten if Refinery.is_a_gem
      t.pattern = [Refinery.root.join('test', 'unit', '**', '*_test.rb').to_s]
      t.pattern << Rails.root.join('vendor', 'plugins', '**', 'test', 'unit', '**', '*_test.rb').to_s if Refinery.is_a_gem
      t.verbose = true
      ENV['RAILS_ROOT'] = Rails.root.to_s
    end
    Rake::Task['test:refinery:units'].comment = 'Run the unit tests in Refinery.'

    Rake::TestTask.new(:functionals => 'db:test:prepare') do |t|
      t.libs << Refinery.root.join('test').to_s
      t.libs += Dir[Rails.root.join('vendor', 'plugins', '**', 'test').to_s].flatten if Refinery.is_a_gem
      t.pattern = [Refinery.root.join('test', 'functional', '**', '*_test.rb').to_s]
      t.pattern << Rails.root.join('vendor', 'plugins', '**', 'test', 'functional', '**', '*_test.rb').to_s if Refinery.is_a_gem
      t.verbose = true
      ENV['RAILS_ROOT'] = Rails.root.to_s
    end
    Rake::Task['test:refinery:functionals'].comment = 'Run the functional tests in Refinery.'

    Rake::TestTask.new(:integration => 'db:test:prepare') do |t|
      t.libs << Refinery.root.join('test').to_s
      t.libs += Dir[Rails.root.join('vendor', 'plugins', '**', 'test').to_s]
      t.pattern = [Refinery.root.join('test', 'integration', '**', '*_test.rb').to_s]
      t.pattern << Rails.root.join('vendor', 'plugins', '**', 'test', 'integration', '**', '*_test.rb').to_s if Refinery.is_a_gem
      t.verbose = true
      ENV['RAILS_ROOT'] = Rails.root.to_s
    end
    Rake::Task['test:refinery:integration'].comment = 'Run the integration tests in Refinery.'

    Rake::TestTask.new(:benchmark => 'db:test:prepare') do |t|
      t.libs << Refinery.root.join('test').to_s
      t.pattern = Refinery.root.join('test', 'performance', '**', '*_test.rb')
      t.verbose = true
      t.options = '-- --benchmark'
      ENV['RAILS_ROOT'] = Rails.root.to_s
    end
    Rake::Task['test:refinery:benchmark'].comment = 'Benchmark the performance tests in Refinery'
  end
end

desc 'Removes trailing whitespace across the entire application.'
task :whitespace do
  sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/  /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
end
