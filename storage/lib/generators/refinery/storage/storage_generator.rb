module Refinery
  class StorageGenerator < Rails::Generators::Base

    # Storage has no migrations. Make skip_migrations the default
    class_option :skip_migrations, :type => :boolean, :default => true, :aliases => nil, :group => :runtime,
                 :desc => 'Skip over installing or running migrations.'

    source_root File.expand_path('../templates', __FILE__)

    def rake_db
      rake 'refinery_storage:install:migrations' unless self.options[:skip_migrations]
    end

    def generate_storage_initializer
      template 'config/initializers/refinery/storage.rb.erb',
               File.join(destination_root, 'config', 'initializers', 'refinery', 'storage.rb')
    end

  end
end
