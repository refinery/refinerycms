require 'refinery/generators'

module ::Refinery
  class PagesGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../', __FILE__)
    engine_name "pages"

  end
end
