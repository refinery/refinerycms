require 'thor'

module Refinery
  class CLI < Thor
    include Thor::Actions

    desc "override", "copies files from any Refinery extension that you are using into your application"
    def override(env)
      if (view = env["view"]).present?
        pattern = "{refinery#{File::SEPARATOR},}#{view.split("/").join(File::SEPARATOR)}*.{erb,builder}"
        looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "views", pattern).to_s}

        # copy in the matches
        if (matches = looking_for.map{|d| Dir[d]}.flatten.compact.uniq).any?
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
          puts "Couldn't match any view template files in any extensions like #{view}"
        end
      elsif (controller = env["controller"]).present?
        pattern = "{refinery#{File::SEPARATOR},}#{controller.split("/").join(File::SEPARATOR)}*.rb"
        looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "controllers", pattern).to_s}

        # copy in the matches
        if (matches = looking_for.map{|d| Dir[d]}.flatten.compact.uniq).any?
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
          puts "Couldn't match any controller files in any extensions like #{controller}"
        end
      elsif (model = env["model"]).present?
        pattern = "{refinery#{File::SEPARATOR},}#{model.split("/").join(File::SEPARATOR)}*.rb"
        looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "models", pattern).to_s}

        # copy in the matches
        if (matches = looking_for.map{|d| Dir[d]}.flatten.compact.uniq).any?
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
          puts "Couldn't match any model files in any extensions like #{model}"
        end
      elsif (javascripts = env["javascript"]).present?
        pattern = "#{javascripts.split("/").join(File::SEPARATOR)}*.js"
        looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "assets", "javascripts", pattern).to_s}

        # copy in the matches
        if (matches = looking_for.map{|d| Dir[d]}.flatten.compact.uniq).any?
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
          puts "Couldn't match any javascript files in any extensions like #{javascripts}"
        end
      elsif (stylesheets = env["stylesheet"]).present?
        pattern = "#{stylesheets.split("/").join(File::SEPARATOR)}*.css.scss"
        looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", "assets", "stylesheets", pattern).to_s}

        # copy in the matches
        if (matches = looking_for.map{|d| Dir[d]}.flatten.compact.uniq).any?
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
          puts "Couldn't match any stylesheet files in any extensions like #{stylesheets}"
        end
      else
        puts "You didn't specify anything to override. Here are some examples:"
        {
          :view => ['pages/home', 'refinery/pages/home', '**/*menu', '_menu_branch'],
          :javascript => %w(admin refinery/site_bar),
          :stylesheet => %w(home refinery/site_bar),
          :controller => %w(pages),
          :model => %w(page refinery/page)
        }.each do |type, examples|
          examples.each do |example|
            puts "rake refinery:override #{type}=#{example}"
          end
        end
      end

    end

    desc "uncrudify", "shows you the code that your controller using crudify is running for a given action"
    def uncrudify(controller, action)
      unless (controller_name = controller).present? and (action = action).present?
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
  end
end
