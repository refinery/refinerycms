require 'refinery/generators'

module ::Refinery
  class Settings < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../', __FILE__)
    engine_name "settings"

  end
end