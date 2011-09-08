require 'refinery/generators'

module ::Refinery
  class ResourcesGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../', __FILE__)
    engine_name "resources"
    
    def generate_resources_initializer
      template "lib/generators/templates/config/initializers/refinery_resources.rb.erb", destination_path.join("config", "initializers", "refinery_resources.rb")
    end

  end
end
