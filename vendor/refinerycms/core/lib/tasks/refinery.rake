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

  desc "Un-crudify a method on a controller that uses crudify"
  task :uncrudify => :environment do
    if (model_name = ENV["model"]).present? and (action = ENV["action"]).present?
      singular_name = model_name.to_s
      class_name = singular_name.camelize
      plural_name = singular_name.pluralize

      crud_lines = Refinery.root.join('vendor', 'refinerycms', 'core', 'lib', 'refinery', 'crud.rb').read
      if (matches = crud_lines.scan(/(\ +)(def #{action}.+?protected)/m).first).present? and
         (method_lines = "#{matches.last.split(%r{^#{matches.first}end}).first.strip}\nend".split("\n")).many?
        indent = method_lines.second.index(%r{[^ ]})
        crud_method = method_lines.join("\n").gsub(/^#{" " * indent}/, "  ")

        default_crud_options = ::Refinery::Crud.default_options(model_name)
        crud_method.gsub!('#{options[:redirect_to_url]}', default_crud_options[:redirect_to_url])
        crud_method.gsub!('#{options[:conditions].inspect}', default_crud_options[:conditions].inspect)
        crud_method.gsub!('#{options[:title_attribute]}', default_crud_options[:title_attribute])
        crud_method.gsub!('#{singular_name}', singular_name)
        crud_method.gsub!('#{class_name}', class_name)
        crud_method.gsub!('#{plural_name}', plural_name)
        crud_method.gsub!('\\#{', '#{')

        puts crud_method
      end
    else
      puts "You didn't specify anything to uncrudify. Here's some examples:"
      puts "rake refinery:uncrudify model=page action=create"
      puts "rake refinery:uncrudify model=product action=new"
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

    Dir[Refinery.root.join('db', 'seeds', '*.rb').cleanpath.to_s].each do |seed|
      unless (destination = Rails.root.join('db', 'seeds', seed.split(File::SEPARATOR).last).cleanpath).exist?
        FileUtils::cp seed, destination.to_s, :verbose => verbose
      end
    end

    puts "\n" if verbose

    unless (ENV["from_installer"] || 'false').to_s == 'true'
      puts "\n=== ACTION REQUIRED ==="
      puts "Please run rake db:migrate to ensure your database is at the correct version.\n"
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

desc 'Removes trailing whitespace across the entire application.'
task :whitespace do
  require 'rbconfig'
  if Config::CONFIG['host_os'] =~ /linux/
    sh %{find . -name '*.*rb' -exec sed -i 's/\t/  /g' {} \\; -exec sed -i 's/ *$//g' {} \\; }
  elsif Config::CONFIG['host_os'] =~ /darwin/
    sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/  /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
  else
    puts "This doesn't work on systems other than OSX or Linux. Please use a custom whitespace tool for your platform '#{Config::CONFIG["host_os"]}'."
  end
end