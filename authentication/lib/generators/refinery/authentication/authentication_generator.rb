require 'refinery/generators'

module Refinery
  class AuthenticationGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../../', __FILE__)
    engine_name "authentication"

  end
end
