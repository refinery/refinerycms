namespace :refinery do

  desc "Override files for use in an application"
  task :override => :environment do
    require 'fileutils'

    if (view = ENV["view"]).present?
      pattern = "#{view.split("/").join(File::SEPARATOR)}*.{erb,builder}"
      looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "views", pattern).to_s}

      # copy in the matches
      matches = looking_for.collect{|d| Dir[d]}.flatten.compact.uniq
      if matches.any?
        matches.each do |match|
          dir = match.split("/app/views/").last.split('/')
          file = dir.pop # get rid of the file.
          dir = dir.join(File::SEPARATOR) # join directory back together

          destination_dir = Rails.root.join("app", "views", dir)
          FileUtils.mkdir_p(destination_dir)
          FileUtils.cp match, (destination = File.join(destination_dir, file))

          puts "Copied view template file to #{destination.gsub("#{Rails.root.to_s}#{File::SEPARATOR}", '')}"
        end
      else
        puts "Couldn't match any view template files in any engines like #{view}"
      end
    elsif (controller = ENV["controller"]).present?
      pattern = "#{controller.split("/").join(File::SEPARATOR)}*.rb"
      looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "controllers", pattern).to_s}

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
      looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "models", pattern).to_s}

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
    elsif (javascripts = ENV["javascript"]).present?
      pattern = "#{javascripts.split("/").join(File::SEPARATOR)}*.js"
      looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "assets", "javascripts", pattern).to_s}

      # copy in the matches
      matches = looking_for.collect{|d| Dir[d]}.flatten.compact.uniq
      if matches.any?
        matches.each do |match|
          dir = match.split("/app/assets/javascripts/").last.split('/')
          file = dir.pop # get rid of the file.
          dir = dir.join(File::SEPARATOR) # join directory back together

          destination_dir = Rails.root.join("app", "assets", "javascripts", dir)
          FileUtils.mkdir_p(destination_dir)
          FileUtils.cp match, (destination = File.join(destination_dir, file))

          puts "Copied javascript file to #{destination.gsub("#{Rails.root.to_s}#{File::SEPARATOR}", '')}"
        end
      else
        puts "Couldn't match any javascript files in any engines like #{javascript}"
      end
    elsif (stylesheets = ENV["stylesheet"]).present?
      pattern = "#{stylesheets.split("/").join(File::SEPARATOR)}*.css.scss"
      looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "assets", "stylesheets", pattern).to_s}

      # copy in the matches
      matches = looking_for.collect{|d| Dir[d]}.flatten.compact.uniq
      if matches.any?
        matches.each do |match|
          dir = match.split("/app/assets/stylesheets/").last.split('/')
          file = dir.pop # get rid of the file.
          dir = dir.join(File::SEPARATOR) # join directory back together

          destination_dir = Rails.root.join("app", "assets", "stylesheets", dir)
          FileUtils.mkdir_p(destination_dir)
          FileUtils.cp match, (destination = File.join(destination_dir, file))

          puts "Copied stylesheet file to #{destination.gsub("#{Rails.root.to_s}#{File::SEPARATOR}", '')}"
        end
      else
        puts "Couldn't match any stylesheet files in any engines like #{stylesheets}"
      end
    else
      puts "You didn't specify anything to override. Here are some examples:"
      {
        :view => ['refinery/pages/home', '**/*menu', 'refinery/_menu_branch'],
        :javascript => %w(admin refinery/site_bar),
        :stylesheet => %w(home refinery/site_bar),
        :controller => %w(refinery/pages),
        :model => %w(refinery/page)
      }.each do |type, examples|
        examples.each do |example|
          puts "rake refinery:override #{type}=#{example}"
        end
      end
    end
  end

  desc "Un-crudify a method on a controller that uses crudify"
  task :uncrudify => :environment do
    unless (controller_name = ENV["controller"]).present? and (action = ENV["action"]).present?
      abort <<-HELPDOC.strip_heredoc
        You didn't specify anything to uncrudify. Here's some examples:
        rake refinery:uncrudify controller=refinery/admin/pages action=create
        rake refinery:uncrudify controller=products action=new
      HELPDOC
    end

    controller_class_name = "#{controller_name}_controller".classify
    begin
      controller_class = controller_class_name.constantize
    rescue NameError
      abort "#{controller_class_name} is not defined"
    end

    crud_lines = Refinery.roots(:'refinery/core').join('lib', 'refinery', 'crud.rb').read
    if (matches = crud_lines.scan(/(\ +)(def #{action}.+?protected)/m).first).present? and
       (method_lines = "#{matches.last.split(%r{^#{matches.first}end}).first.strip}\nend".split("\n")).many?
      indent = method_lines.second.index(%r{[^ ]})
      crud_method = method_lines.join("\n").gsub(/^#{" " * indent}/, "  ")

      crud_options = controller_class.try(:crudify_options) || {}
      crud_method.gsub!('#{options[:redirect_to_url]}', crud_options[:redirect_to_url].to_s)
      crud_method.gsub!('#{options[:conditions].inspect}', crud_options[:conditions].inspect)
      crud_method.gsub!('#{options[:title_attribute]}', crud_options[:title_attribute])
      crud_method.gsub!('#{singular_name}', crud_options[:singular_name])
      crud_method.gsub!('#{class_name}', crud_options[:class_name])
      crud_method.gsub!('#{plural_name}', crud_options[:plural_name])
      crud_method.gsub!('\\#{', '#{')

      puts crud_method
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
  if RbConfig::CONFIG['host_os'] =~ /linux/
    sh %{find . -name '*.*rb' -exec sed -i 's/\t/  /g' {} \\; -exec sed -i 's/ *$//g' {} \\; }
  elsif RbConfig::CONFIG['host_os'] =~ /darwin/
    sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/  /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
  else
    puts "This doesn't work on systems other than OSX or Linux. Please use a custom whitespace tool for your platform '#{RbConfig::CONFIG["host_os"]}'."
  end
end

desc "Recalculate $LOAD_PATH frequencies."
task :recalculate_loaded_features_frequency => :environment do
  require 'refinery/load_path_analyzer'

  frequencies     = LoadPathAnalyzer.new($LOAD_PATH, $LOADED_FEATURES).frequencies
  ideal_load_path = frequencies.to_a.sort_by(&:last).map(&:first)

  Rails.root.join('config', 'ideal_load_path').open("w") do |f|
    f.puts ideal_load_path
  end
end
