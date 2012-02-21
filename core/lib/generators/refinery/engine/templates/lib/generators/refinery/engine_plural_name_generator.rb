module Refinery
  class <%= engine_plural_class_name %>Generator < Rails::Generators::Base

    def rake_db
      rake("refinery_<%= engine_plural_name %>:install:migrations")
    end

    def append_load_seed_data
      create_file 'db/seeds.rb' unless File.exists?(File.join(destination_root, 'db', 'seeds.rb'))
      append_file 'db/seeds.rb', :verbose => true do
        <<-EOH
Refinery::<%= namespacing %>::Engine.load_seed
        EOH
      end
    end
  end
end
