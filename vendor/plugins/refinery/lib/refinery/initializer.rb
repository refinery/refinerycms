module Refinery
  if defined? Rails::Configuration
    class Configuration < Rails::Configuration
      def default_plugin_paths
        paths = super.push("#{REFINERY_ROOT}/vendor/plugins").uniq
      end
    end
  end
  if defined? Rails::Initializer
    class Initializer < Rails::Initializer
      def self.run(command = :process, configuration = Configuration.new)
        Rails.configuration = configuration
        super
      end
  
      def load_plugins
        Refinery.add_gems
        super
      end
    end
  end
end