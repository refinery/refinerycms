require 'refinery/generators'

class RefinerycmsAuthentication < ::Refinery::Generators::EngineInstaller

  source_root File.expand_path('../../../', __FILE__)
  engine_name "authentication"

end
