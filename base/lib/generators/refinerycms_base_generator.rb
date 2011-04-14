require 'refinery/generators'

class ::Refinery::RefinerycmsBase < ::Refinery::Generators::EngineInstaller

  source_root File.expand_path('../../../', __FILE__)
  engine_name "base"

end
