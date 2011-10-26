require 'refinery/generators'

module Refinery
  class CoreGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../../../', __FILE__)
    engine_name "core"

    def generate_refinery_initializer
      template "lib/refinery/generators/core/templates/config/initializers/refinery.rb.erb", destination_path.join("config", "initializers", "refinery.rb")
    end

  end
end
