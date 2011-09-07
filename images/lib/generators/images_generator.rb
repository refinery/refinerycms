require 'refinery/generators'

module Refinery
  class ImagesGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../', __FILE__)
    engine_name "images"

    def generate_resource_config_files
      template "lib/generators/templates/config/initializers/refinery_images.rb.erb", destination_path.join("config", "initializers", "refinery_images.rb")
    end
    
  end
end
