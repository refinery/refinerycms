require 'refinery/generators'

module ::Refinery
  class SettingsGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../../', __FILE__)
    engine_name "settings"

  end
end
