begin
  # Try to include the rails initializer. If this isn't in a gem, this will fail.
  require 'initializer' unless REFINERY_ROOT == RAILS_ROOT # A Refinery gem install's RAILS_ROOT is not the REFINERY_ROOT.
rescue LoadError => load_error
end

module Refinery
  if defined? Rails::Configuration
    class Configuration < Rails::Configuration
      def default_plugin_paths
        paths = super.push("#{REFINERY_ROOT}/vendor/plugins").uniq
      end
    end
  end
  if defined? Rails::Plugin::Loader
    class GemedPluginLoader < Rails::Plugin::Loader
      def add_plugin_load_paths
        super
        # add plugin lib paths to the $LOAD_PATH so that rake tasks etc. can be run when using a gem.
        plugins.each do |plugin|
          plugin.load_paths.reject { |path| path.scan(/refinerycms.+?vendor\/plugins\/.+?\/lib/).empty? }.each do |path|
            $LOAD_PATH.unshift path
          end
        end
      end
    end
  end
  if defined? Rails::Initializer
    class Initializer < Rails::Initializer
      def self.run(command = :process, configuration = Configuration.new)
        Rails.configuration = configuration
        configuration.reload_plugins = true if RAILS_ENV =~ /development/ and REFINERY_ROOT == RAILS_ROOT # seems to work, don't in gem.
        configuration.plugin_loader = Refinery::GemedPluginLoader unless REFINERY_ROOT == RAILS_ROOT # only do this in a gem.
        super
      end

      def load_plugins
        Refinery.add_gems
        super
      end
    end
  end
end
