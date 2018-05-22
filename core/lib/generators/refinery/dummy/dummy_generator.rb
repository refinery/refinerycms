require 'rails/generators/rails/app/app_generator'

module Refinery
  class DummyGenerator < Rails::Generators::Base
    desc "Creates a blank Rails application with Refinery CMS installed."

    class_option :database, :default => ''

    def self.source_paths
      [
        self.superclass.source_paths,
        File.expand_path('../templates', __FILE__)
      ].flatten.compact
    end

    PASSTHROUGH_OPTIONS = [
      :database,
      :force,
      :javascript,
      :pretend,
      :quiet,
      :skip,
      :skip_action_cable,
      :skip_action_mailer,
      :skip_active_record,
      :skip_javascript
    ]

    def generate_test_dummy
      opts = (options || {}).slice(*PASSTHROUGH_OPTIONS)
      opts[:database] = 'sqlite3' if opts[:database].blank?
      opts[:force] = true
      opts[:skip_bundle] = true
      opts[:skip_action_cable] = true
      opts[:skip_action_mailer] = true
      opts[:skip_keeps] = true
      opts[:skip_seeds] = true
      opts[:template] = refinery_path.join("templates", "refinery", "edge.rb").to_s

      invoke Rails::Generators::AppGenerator,
             [ File.expand_path(dummy_path, destination_root) ],
             opts
    end

    def test_dummy_config
      @database = options[:database]

      template "rails/database.yml", "#{dummy_path}/config/database.yml", :force => true
      template "rails/boot.rb.erb", "#{dummy_path}/config/boot.rb", :force => true
      template "rails/application.rb.erb", "#{dummy_path}/config/application.rb", :force => true
      template "rails/routes.rb", "#{dummy_path}/config/routes.rb", :force => true
      template "rails/Rakefile", "#{dummy_path}/Rakefile", :force => true
      template "rails/application.js", "#{dummy_path}/app/assets/javascripts/application.js", :force => true
      template 'rails/blank.png', "#{dummy_path}/public/apple-touch-icon.png", :force => true
      template 'rails/blank.png', "#{dummy_path}/public/apple-touch-icon-precomposed.png", :force => true
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

    def test_dummy_inherited_templates
      template "rails/search_form.html.erb",
        "#{dummy_path}/app/views/application/_search_form.html.erb",
        :force => true
      template "rails/searchable.html.erb",
        "#{dummy_path}/app/views/refinery/pages/searchable.html.erb",
        :force => true
    end

    attr :database

    protected

    def dummy_path
      'spec/dummy'
    end

    def dummy_application_path
      File.expand_path("#{dummy_path}/config/application.rb", destination_root)
    end

    def module_name
      'Dummy'
    end

    def application_definition
      @application_definition ||= begin
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
      "../../../../Gemfile"
    end

    def refinery_path
      Pathname.new File.expand_path("../../../../../../", __FILE__)
    end
  end
end
