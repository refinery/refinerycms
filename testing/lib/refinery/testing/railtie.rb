require 'refinerycms-testing'
require 'rails'

module Refinery
  module Testing
    class Railtie < Rails::Railtie
      railtie_name :refinerycms_testing

      rake_tasks do
        load 'refinery/tasks/rcov.rake'
        load 'refinery/tasks/testing.rake'
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Testing)
        Testing.load_factories
      end
    end
  end
end
