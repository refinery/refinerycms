require 'thor'

module Refinery
  class CLI < Thor
    include Thor::Actions

    OVERRIDES = {
      :view => {
        :glob => '*.{erb,builder}',
        :dir => 'views',
        :desc => 'view template',
      },
      :controller => {
        :glob => '*.rb',
        :dir => 'controllers',
        :desc => 'controller',
      },
      :model => {
        :glob => '*.rb',
        :dir => 'models',
        :desc => 'model',
      },
      :presenter => {
        :glob => '*.rb',
        :dir => 'presenters',
        :desc => 'presenter',
      },
      :javascript => {
        :glob => '*.js{,.*}',
        :dir => 'assets/javascripts',
        :desc => 'javascript',
      },
      :stylesheet => {
        :glob => '*.css.scss',
        :dir => 'assets/stylesheets',
        :desc => 'stylesheet',
      },
    }

    desc "override", "copies files from any Refinery extension that you are using into your application"
    def override(env)
      OVERRIDES.keys.each do |kind|
        if (which = env[kind.to_s]).present?
          return _override(kind, which)
        end
      end

      puts "You didn't specify anything valid to override. Here are some examples:"
      {
        :view => ['pages/home', 'refinery/pages/home', '**/*menu', '_menu_branch'],
        :javascript => %w(admin refinery/site_bar),
        :stylesheet => %w(home refinery/site_bar),
        :controller => %w(pages),
        :model => %w(page refinery/page),
        :presenter => %w(refinery/page_presenter)
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
      override_kind = OVERRIDES[kind]
      pattern = "{refinery#{File::SEPARATOR},}#{which.split("/").join(File::SEPARATOR)}#{override_kind[:glob]}"
      looking_for = ::Refinery::Plugins.registered.pathnames.map{|p| p.join("app", override_kind[:dir], pattern).to_s}

      # copy in the matches
      if (matches = looking_for.map{|d| Dir[d]}.flatten.compact.uniq).any?
        matches.each do |match|
          dir = match.split("/app/#{override_kind[:dir]}/").last.split('/')
          file = dir.pop # get rid of the file.
          dir = dir.join(File::SEPARATOR) # join directory back together

          destination_dir = Rails.root.join('app', override_kind[:dir], dir)
          FileUtils.mkdir_p(destination_dir)
          FileUtils.cp match, (destination = File.join(destination_dir, file))

          puts "Copied #{override_kind[:desc]} file to #{destination.gsub("#{Rails.root.to_s}#{File::SEPARATOR}", '')}"
        end
      else
        puts "Couldn't match any #{override_kind[:desc]} files in any extensions like #{which}"
      end
    end
  end
end
