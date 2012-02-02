require 'yaml'
require 'pathname'
require 'rails/generators/named_base'

module Refinery
  class EngineGenerator < Rails::Generators::NamedBase
    source_root Pathname.new(File.expand_path('../templates', __FILE__))
    argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
    class_option :namespace, :type => :string, :default => nil, :banner => 'NAMESPACE', :required => false
    class_option :engine, :type => :string, :default => nil, :banner => 'ENGINE', :required => false
    class_option :skip_frontend, :type => :boolean, :default => false, :required => false, :desc => 'Generate engine without frontend'
    remove_class_option :skip_namespace

    def namespacing
      @namespacing ||= if options[:namespace].present?
        # Use exactly what the user requested, not a pluralised version.
        options[:namespace].to_s.camelize
      else
        class_name.pluralize
      end
    end

    def engine_name
      @engine_name ||= if options[:engine].present?
        # Use exactly what the user requested, not a made up version.
        options[:engine].to_s
      else
        singular_name
      end
    end

    def engine_class_name
      @engine_class_name ||= engine_name.camelize
    end

    def engine_plural_class_name
      @engine_plural_class_name ||= if options[:engine].present?
        # Use exactly what the user requested, not a plural version.
        engine_class_name
      else
        engine_class_name.pluralize
      end
    end

    def engine_plural_name
      @engine_plural_name ||= if options[:engine].present?
        # Use exactly what the user requested, not a plural version.
        engine_name
      else
        engine_name.pluralize
      end
    end

    def skip_frontend?
      options[:skip_frontend]
    end

    def generate
      destination_pathname = Pathname.new(self.destination_root)
      clash_file = Pathname.new(File.expand_path('../clash_keywords.yml', __FILE__))
      clash_keywords = File.open(clash_file) { |f| doc = YAML.load(f) }
      if clash_keywords.member?(singular_name.downcase)
        puts "Please choose a different name.  Generated code would fail for class '#{singular_name}'"
        puts ""
        exit(1)
      end

      if singular_name == plural_name
        puts ""
        if singular_name.singularize != singular_name
          puts "Please specify the singular name '#{singular_name.singularize}' instead of '#{plural_name}'."
        else
          puts "The engine name you specified will not work as the singular name is equal to the plural name."
        end
        puts ""
        exit(1)
      end

      if attributes.any? || self.behavior == :revoke
        Pathname.glob(Pathname.new(self.class.source_root).join('**', '**')).reject{|f| f.directory? or reject_file?(f) }.sort.each do |path|
          unless (engine_path = engine_path_for(path, engine_name)).nil?
            template path, engine_path
          end
        end

        application_gemfile = Bundler.default_gemfile || destination_pathname.join('Gemfile')
        gemfile_entry = application_gemfile.read.scan(%r{refinerycms-#{engine_plural_name}}).any?

        existing_engine = options[:engine].present? &&
                          destination_pathname.join('vendor', 'engines', engine_plural_name).directory? &&
                          gemfile_entry

        if existing_engine
          # go through all of the temporary files and merge what we need into the current files.
          tmp_directories = []
          Dir.glob(File.expand_path("../templates/{config/locales/*.yml,config/routes.rb,lib/refinerycms-engine_plural_name.rb}", __FILE__), File::FNM_DOTMATCH).sort.each do |path|
            # get the path to the current tmp file.
            new_file_path = destination_pathname.join(engine_path_for(path, engine_name))
            tmp_directories << Pathname.new(new_file_path.to_s.split(File::SEPARATOR)[0..-2].join(File::SEPARATOR)) # save for later
            # get the path to the existing file and perform a deep hash merge.
            current_path = Pathname.new(new_file_path.to_s.split(File::SEPARATOR).reject{|f| f == 'tmp'}.join(File::SEPARATOR))
            new_contents = nil
            if new_file_path.to_s =~ %r{.yml$}
              # merge translation files together.
              new_contents = YAML::load(new_file_path.read).deep_merge(YAML::load(current_path.read)).to_yaml.gsub(%r{^---\n}, '')
            elsif new_file_path.to_s =~ %r{/routes.rb$}
              # append any routes from the new file to the current one.
              routes_file = [(file_parts = current_path.read.to_s.split("\n")).first]
              routes_file += file_parts[1..-2]
              routes_file += new_file_path.read.to_s.split("\n")[1..-2]
              routes_file << file_parts.last
              new_contents = routes_file.join("\n")
            elsif new_file_path.to_s =~ %r{/refinerycms-#{engine_plural_name}.rb$}
              new_contents = current_path.read + new_file_path.read
            end
            # write to current file the merged results.
            current_path.open('w+') { |f| f.puts new_contents } unless new_contents.nil?
          end

          tmp_directories.uniq.each{|d| remove_dir(d) unless d.nil? or !d.exist?}
        end

        unless Rails.env.test? || (self.behavior != :revoke && gemfile_entry)
          path = destination_pathname.join('vendor', 'engines').relative_path_from(application_gemfile.parent)
          append_file application_gemfile,
                      "\ngem 'refinerycms-#{engine_plural_name}', :path => '#{path}'"
        end

        # Update the gem file (only if no gemfile_entry already)
        if self.behavior != :revoke and !self.options['pretend']
          unless Rails.env.test?
            puts "------------------------"
            puts "Now run:"
            puts "bundle install"
            puts "rails generate refinery:#{engine_plural_name}"
            puts "rake db:migrate"
            puts "------------------------"
          end
        else
          engine_path = destination_pathname.join('vendor', 'engines', engine_plural_name)
          if Pathname.glob(engine_path.join('**', '*')).all?(&:directory?)
            say_status :remove, relative_to_original_destination_root(engine_path.to_s), true
            FileUtils.rm_rf engine_path unless options[:pretend]
          end
        end
      else
        puts "You must specify at least one field. For help: rails generate refinery:engine"
      end
    end

  protected

    def engine_path_for(path, engine)
      engine_path = "vendor/engines/#{engine_plural_name}"
      path = path.to_s.gsub(File.expand_path('../templates', __FILE__), engine_path)

      path.gsub!("engine_plural_name", engine_plural_name)
      path.gsub!("plural_name", plural_name)
      path.gsub!("singular_name", singular_name)
      path.gsub!("namespace", namespacing.underscore)

      if options[:namespace].present? || options[:engine].present?
        # Increment the migration file leading number
        # Only relevant for nested or namespaced engines, where a previous migration exists
        if path =~ %r{/migrate/\d+\w*.rb\z}
          if last_migration = Dir["#{File.join(self.destination_root, path.split(File::SEPARATOR)[0..-2], '*.rb')}"].sort.last
            path.gsub!(%r{\d+_}) { |m| "#{last_migration.match(%r{migrate/(\d+)_})[1].to_i + 1}_" }
          end
        end

        # Detect whether this is a special file that needs to get merged not overwritten.
        # This is important only when nesting engines.
        if engine.present? && File.exist?(path)
          path = if path =~ %r{/locales/.*\.yml$} or path =~ %r{/routes.rb$} or path =~ %r{/refinerycms-#{engine_plural_name}.rb$}
            # put new translations into a tmp directory
            path.split(File::SEPARATOR).insert(-2, "tmp").join(File::SEPARATOR)
          elsif path =~ %r{/readme.md$} or path =~ %r{/#{plural_name}.rb$}
            nil
          else
            path
          end
        elsif engine.present? and path =~ /lib\/#{plural_name}.rb$/
          path = nil
        end
      end

      path
    end

    def reject_file?(file)
      skip_frontend? and (file.to_s.include?('app') and not file.to_s.scan(/admin|models/).any?)
    end
  end
end
