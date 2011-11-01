require 'yaml'
require 'pathname'
require 'rails/generators'

module Refinery
  class EngineGenerator < Rails::Generators::NamedBase
    source_root Pathname.new(File.expand_path('../templates', __FILE__))
    argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

    def generate
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

      unless attributes.empty? and self.behavior != :revoke
        if (engine = attributes.detect{|a| a.type.to_s == 'engine'}).present? and attributes.reject!{|a| a.type.to_s == 'engine'}.present?
          engine = engine.name.pluralize
        end

        Pathname.glob(Pathname.new(self.class.source_root).join('**', '**')).reject{|f| f.directory?}.sort.each do |path|
          unless (engine_path = engine_path_for(path, engine)).nil?
            template path, engine_path
          end
        end

        if engine.present?
          # go through all of the temporary files and merge what we need into the current files.
          tmp_directories = []
          Dir.glob(File.expand_path('../templates/{config/locales/*.yml,config/routes.rb}', __FILE__), File::FNM_DOTMATCH).sort.each do |path|
            # get the path to the current tmp file.
            new_file_path = Rails.root.join(engine_path_for(path, engine))
            tmp_directories << Pathname.new(new_file_path.to_s.split(File::SEPARATOR)[0..-2].join(File::SEPARATOR)) # save for later

            # get the path to the existing file and perform a deep hash merge.
            current_path = Pathname.new(new_file_path.to_s.split(File::SEPARATOR).reject{|f| f == 'tmp'}.join(File::SEPARATOR))
            new_contents = nil
            if new_file_path.to_s =~ %r{.yml$}
              # merge translation files together.
              new_contents = YAML::load(new_file_path.read).deep_merge(YAML::load(current_path.read)).to_yaml
            elsif new_file_path.to_s =~ %r{/routes.rb$}
              # append any routes from the new file to the current one.
              routes_file = [(file_parts = current_path.read.to_s.split("\n")).first]
              routes_file += file_parts[1..-2]
              routes_file += new_file_path.read.to_s.split("\n")[1..-2]
              routes_file << file_parts.last
              new_contents = routes_file.join("\n")
            end
            # write to current file the merged results.
            current_path.open('w+') { |f| f.puts new_contents } unless new_contents.nil?
          end

          if File.exist?(lib_file = engine_path_for(File.expand_path("../templates/lib/refinerycms-#{engine.pluralize}.rb", __FILE__), engine))
            append_file lib_file, "\nrequire File.expand_path('../refinerycms-#{plural_name}', __FILE__)"
          end

          tmp_directories.uniq.each{|d| d.rmtree unless d.nil? or !d.exist?}
        end

        # Update the gem file
        if self.behavior != :revoke and !self.options['pretend']
          unless Rails.env.test?
            Rails.root.join('Gemfile').open('a') do |f|
              f.write "\ngem 'refinerycms-#{plural_name}', '1.0', :path => 'vendor/engines'"
            end unless engine.present?

            puts "------------------------"
            puts "Now run:"
            puts "bundle install"
            unless engine.present?
              puts "rake refinery_#{plural_name}:install:migrations"
            else
              puts "rails generate refinery:#{engine} #{plural_name}"
            end
            puts "rake db:migrate"
            puts "------------------------"
          end
        elsif self.behavior == :revoke
          lines = Rails.root.join('Gemfile').open('r').read.split("\n")
          Rails.root.join('Gemfile').open('w').puts(lines.reject {|l|
            l =~ %r{refinerycms-#{plural_name}}
          }.join("\n"))

          ::Refinery::Generators::Migrations.revoke({
            :pattern => File.expand_path('../templates/db/migrate/*.rb', __FILE__),
            :plural_name => plural_name,
            :singular_name => singular_name
          })
        end
      else
        puts "You must specify at least one field. For help: rails generate refinery:engine"
      end
    end

  protected

    def engine_path_for(path, engine)
      engine_path = "vendor/engines/#{engine.present? ? engine : plural_name}/"
      path = path.to_s.gsub(File.expand_path('../templates', __FILE__), engine_path)

      path = path.gsub("plural_name", plural_name)
      path = path.gsub("singular_name", singular_name)

      # Detect whether this is a special file that needs to get merged not overwritten.
      # This is important only when nesting engines.
      if engine.present? and File.exist?(path)
        path = if path =~ %r{/locales/.*\.yml$} or path =~ %r{/routes.rb$}
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

      path
    end

  end
end
