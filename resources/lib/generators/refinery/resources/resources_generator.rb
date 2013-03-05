module Refinery
  class ResourcesGenerator < Rails::Generators::Base
    class_option :skip_migrations, :type => :boolean, :default => false, :aliases => nil, :group => :runtime,
                           :desc => "Skip over installing or running migrations."

    source_root File.expand_path('../templates', __FILE__)

    def rake_db
      rake "refinery_resources:install:migrations" unless self.options[:skip_migrations]
    end

    def generate_resources_initializer
      template "config/initializers/refinery/resources.rb.erb",
               File.join(destination_root, "config", "initializers", "refinery", "resources.rb")
    end

  end
end
