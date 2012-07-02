require 'thor'

module Refinery
  class CLI < Thor
    include Thor::Actions

    KIND_EXTS = {
      'view' => '{erb,builder}',
      'controller' => 'rb',
      'model' => 'rb',
      'javascript' => 'js{,.*}',
      'stylesheet' => 'css.scss'
    }
    KIND_DIRS = {
      'view' => 'views',
      'controller' => 'controllers',
      'model' => 'models',
      'javascript' => 'assets/javascripts',
      'stylesheet' => 'assets/stylesheets'
    }
    KIND_DESCS = {
      'view' => 'view template',
      'controller' => 'controller',
      'model' => 'model',
      'javascript' => 'javascript',
      'stylesheet' => 'stylesheet'
    }

    desc "override", "copies files from any Refinery extension that you are using into your application"
    def override(env)
      for kind in %w(view controller model javascript stylesheet)
        if (which = env[kind]).present?
          return _override(kind, which)
        end
      end

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


    private

    def _override(kind, which)
      pattern = "{refinery#{File::SEPARATOR},}#{which.split("/").join(File::SEPARATOR)}*.#{KIND_EXTS[kind]}"
      looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", KIND_DIRS[kind], pattern).to_s}

      # copy in the matches
      if (matches = looking_for.map{|d| Dir[d]}.flatten.compact.uniq).any?
        matches.each do |match|
          dir = match.split("/app/#{KIND_DIRS[kind]}/").last.split('/')
          file = dir.pop # get rid of the file.
          dir = dir.join(File::SEPARATOR) # join directory back together

          destination_dir = Rails.root.join("app", KIND_DIRS[kind], dir)
          FileUtils.mkdir_p(destination_dir)
          FileUtils.cp match, (destination = File.join(destination_dir, file))

          puts "Copied #{KIND_DESCS[kind]} file to #{destination.gsub("#{Rails.root.to_s}#{File::SEPARATOR}", '')}"
        end
      else
        puts "Couldn't match any #{KIND_DESCS[kind]} files in any extensions like #{which}"
      end
    end
  end
end
