require 'refinerycms-testing'
require 'rails'

module Refinery
  module Testing
    class Railtie < Rails::Railtie
      railtie_name :refinerycms_testing

      rake_tasks do
        load 'refinery/tasks/rcov.rake'
        load 'refinery/tasks/testing.rake'
        load 'refinery/tasks/rspec.rake'
      end

      config.after_initialize do
        Refinery.engines << 'testing'
      end
    end
  end
end
