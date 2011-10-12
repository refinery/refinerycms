require 'refinery/generators'

module Refinery
  class PagesGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../../', __FILE__)
    engine_name "pages"

    def generate_pages_initializer
      template "lib/refinery/generators/templates/config/initializers/refinery_pages.rb.erb", destination_path.join("config", "initializers", "refinery_pages.rb")
    end

  end
end
