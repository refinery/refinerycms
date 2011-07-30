require 'refinery/generators'

module ::Refinery
  class ImagesGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../', __FILE__)
    engine_name "images"

  end
end
