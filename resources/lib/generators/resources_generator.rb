require 'refinery/generators'

module ::Refinery
  class ResourcesGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../templates', __FILE__)
    engine_name "resources"
    
    def generate_resource_config_files
      template "config/refinery_resource_config.yml", destination_path.join("config", "refinery_resource_config.yml")
    end

  end
end
