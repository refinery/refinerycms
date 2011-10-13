module Refinery
  module Generators
    autoload :EngineInstaller, 'refinery/generators/engine_installer'
    autoload :Migrations, 'refinery/generators/migrations'
  end
  
  autoload :EngineGenerator, 'refinery/generators/engine/engine_generator'
  autoload :CmsGenerator, 'refinery/generators/cms/cms_generator'
  autoload :CoreGenerator, 'refinery/generators/core/core_generator'
end
