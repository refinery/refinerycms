require 'refinery/generators'

class RefinerycmsTesting < ::Refinery::Generators::EngineInstaller

  source_root File.expand_path('../../../', __FILE__)
  engine_name "testing"

  def generate
    copy_file 'config/cucumber.yml', Rails.root.join('config', 'cucumber.yml')
    copy_file 'spec/spec_helper.rb', Rails.root.join('spec', 'spec_helper.rb')
    copy_file 'spec/rcov.opts', Rails.root.join('spec', 'rcov.opts')
    copy_file '.rspec', Rails.root.join('.rspec')
  end

end
