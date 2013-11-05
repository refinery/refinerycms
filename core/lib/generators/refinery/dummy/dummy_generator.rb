require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Refinery
  class DummyGenerator < Rails::Generators::Base
    desc "Creates blank Rails application, installs Refinery CMS, and all sample data"

    class_option :database, :default => ''

    def self.source_paths
      paths = self.superclass.source_paths
      paths << File.expand_path('../templates', __FILE__)
      paths.flatten
    end

    PASSTHROUGH_OPTIONS = [
      :skip_active_record, :skip_javascript, :database, :javascript, :quiet, :pretend, :force, :skip
    ]

    def generate_test_dummy
      opts = (options || {}).slice(*PASSTHROUGH_OPTIONS)
      opts[:database] = 'sqlite3' if opts[:database].blank?
      opts[:force] = true
      opts[:skip_bundle] = true
      opts[:old_style_hash] = true

      invoke Rails::Generators::AppGenerator, [ File.expand_path(dummy_path, destination_root) ], opts
    end

    def test_dummy_config
      @database = options[:database]

      template "rails/database.yml", "#{dummy_path}/config/database.yml", :force => true
      template "rails/boot.rb.erb", "#{dummy_path}/config/boot.rb", :force => true
      template "rails/application.rb.erb", "#{dummy_path}/config/application.rb", :force => true
      template "rails/routes.rb", "#{dummy_path}/config/routes.rb", :force => true
      template "rails/Rakefile", "#{dummy_path}/Rakefile", :force => true
      template "rails/application.js", "#{dummy_path}/app/assets/javascripts/application.js", :force => true
    end

    def test_dummy_clean
      inside dummy_path do
        remove_file ".gitignore"
        remove_file "doc"
        remove_file "Gemfile"
        remove_file "lib/tasks"
        remove_file "app/assets/images/rails.png"
        remove_file "public/index.html"
        remove_file "public/robots.txt"
        remove_file "README"
        remove_file "test"
        remove_file "vendor"
      end
    end

    attr :database

  protected

    def dummy_path
      'spec/dummy'
    end

    def module_name
      'Dummy'
    end

    def application_definition
      @application_definition ||= begin
        dummy_application_path = File.expand_path("#{dummy_path}/config/application.rb", destination_root)
        unless options[:pretend] || !File.exists?(dummy_application_path)
          contents = File.read(dummy_application_path)
          contents[(contents.index("module #{module_name}"))..-1]
        end
      end
    end
    alias :store_application_definition! :application_definition

    def camelized
      @camelized ||= name.gsub(/\W/, '_').squeeze('_').camelize
    end

    def gemfile_path
      '../../../../Gemfile'
    end
  end
end
