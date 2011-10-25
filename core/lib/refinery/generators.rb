require 'rails/generators'

module Refinery
  module Generators
    autoload :EngineInstaller, 'refinery/generators/engine_installer'
    autoload :Migrations, 'refinery/generators/migrations'
  end

  require 'refinery/generators/engine/engine_generator'
  require 'refinery/generators/cms/cms_generator'
  require 'refinery/generators/core/core_generator'
  require 'refinery/generators/dummy/dummy_generator'
end
