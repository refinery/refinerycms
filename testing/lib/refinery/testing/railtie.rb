module Refinery
  module Testing
    class Railtie < Rails::Railtie
      railtie_name :refinerycms_testing

      class << self
        attr_reader :target_extension_path # :nodoc:
        alias_method :target_engine_path, :target_extension_path

        # Loads Rake tasks to assist with manipulating dummy applications for testing extensions. Takes
        # a string representing the path to your application or extension.
        #
        # This function should be used in the Rakefile of your application or extension
        #
        # Example:
        #   Refinery::Testing::Railtie.load_dummy_tasks(File.dirname(__FILE__))
        #
        #   Refinery::Testing::Railtie.load_dummy_tasks('/users/reset/code/mynew_app')
        def load_dummy_tasks(app_root)
          @target_extension_path = Pathname.new(app_root.to_s)
          load 'refinery/tasks/testing.rake'
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Testing)
        Testing.load_factories
      end
    end
  end
end
