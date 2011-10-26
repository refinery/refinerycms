module Refinery
  class PagesGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_pages_initializer
      template "config/initializers/refinery_pages.rb.erb", File.join(destination_root, "config", "initializers", "refinery_pages.rb")
    end

  end
end
