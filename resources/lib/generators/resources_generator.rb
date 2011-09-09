require 'refinery/generators'

module ::Refinery
  class ResourcesGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../', __FILE__)
    engine_name "resources"

    def generate_resource_config_files
      template "lib/generators/templates/config/refinery/resources.yml.erb", destination_path.join("config", "refinery","resources.yml")
    end

  end
end
