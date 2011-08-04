require 'refinery/generators'

module ::Refinery
  class TestingGenerator < ::Refinery::Generators::EngineInstaller

    source_root File.expand_path('../../../', __FILE__)
    engine_name "testing"

    def generate
      copy_file 'config/cucumber.yml',
                Rails.root.join('config', 'cucumber.yml')

      copy_file 'lib/generators/templates/spec/spec_helper.rb',
                Rails.root.join('spec', 'spec_helper.rb')

      copy_file 'lib/generators/templates/spec/rcov.opts',
                Rails.root.join('spec', 'rcov.opts')

      copy_file '.rspec',
                Rails.root.join('.rspec')

      copy_file 'lib/generators/templates/features/support/paths.rb',
                Rails.root.join('features', 'support', 'paths.rb')

      copy_file 'lib/generators/templates/Guardfile',
                Rails.root.join('Guardfile')
    end

  end
end
