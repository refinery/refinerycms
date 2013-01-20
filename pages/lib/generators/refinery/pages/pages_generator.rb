module Refinery
  class PagesGenerator < Rails::Generators::Base
    class_option :skip_migrations, :type => :boolean, :default => false, :aliases => nil, :group => :runtime,
                           :desc => "Skip over installing or running migrations."

    source_root File.expand_path('../templates', __FILE__)

    def rake_db
      rake "refinery_pages:install:migrations" unless self.options[:skip_migrations]
    end

    def generate_pages_initializer
      template "config/initializers/refinery/pages.rb.erb",
               File.join(destination_root, "config", "initializers", "refinery", "pages.rb")
    end

    def append_load_seed_data
      create_file "db/seeds.rb" unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH

# Added by Refinery CMS Pages extension
Refinery::Pages::Engine.load_seed
        EOH
      end
    end

  end
end
