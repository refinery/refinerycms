module Refinery
  class PagesGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_pages_initializer
      template "config/initializers/refinery/pages.rb.erb", File.join(destination_root, "config", "initializers", "refinery", "pages.rb")
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
