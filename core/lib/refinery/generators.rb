require 'rails/generators'

module Refinery
  module Generators
    autoload :EngineInstaller, 'refinery/generators/engine_installer'
    autoload :Migrations, 'refinery/generators/migrations'
  end
end
