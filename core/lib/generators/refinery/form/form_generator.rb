require 'rails/generators/migration'
require 'fileutils'

module Refinery
  class FormGenerator < Rails::Generators::NamedBase

    source_root File.expand_path('../templates', __FILE__)
    argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
    class_option :namespace, :type => :string, :default => nil, :banner => 'NAMESPACE', :required => false
    class_option :engine, :type => :string, :default => nil, :banner => 'ENGINE', :required => false

    def description
      "Generates an engine which is set up for frontend form submissions like a contact page."
    end

    def generate
      unless attributes.empty? or plural_name =~ /\:/
        Dir.glob(File.expand_path('../templates/**/**', __FILE__), File::FNM_DOTMATCH).reject{|f|
          File.directory?(f)
        }.each do |path|
          unless (engine_path = engine_path_for(path)).nil?
            template path, engine_path
          end
        end

        # Update the gem file
        unless self.behavior == :revoke
          unless Rails.env.test?
            Rails.root.join('Gemfile').open('a') do |f|
              f.write "\ngem 'refinerycms-#{plural_name}', '1.0', :path => 'vendor/engines'"
            end

            puts "------------------------"
            puts "Now run:"
            puts "bundle install"
            puts "rails generate refinery:#{plural_name}"
            puts "rake db:migrate"
            puts "------------------------"
          end
        else
          lines = Rails.root.join('Gemfile').open('r').read.split("\n")
          Rails.root.join('Gemfile').open('w').puts(lines.reject {|l| l =~ %r{refinerycms-#{plural_name}}}.join("\n"))
          if (dir = Rails.root.join('vendor', 'engines', "#{plural_name}")).directory?
            dir.rmtree
            puts "Removed directory #{dir}"
          end
        end
      else
        puts "You must specify a name and at least one field. For help: rails generate refinery_form"
      end
    end

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


  protected


    def engine_path_for(path)
      engine_path = "vendor/engines/#{plural_name}/"
      path = path.gsub(File.dirname(__FILE__) + "/templates/", engine_path)

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

  end
end
