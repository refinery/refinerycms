require 'refinery/generators'

module Refinery
  class CoreGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../../', __FILE__)
    engine_name "core"

  end
end
