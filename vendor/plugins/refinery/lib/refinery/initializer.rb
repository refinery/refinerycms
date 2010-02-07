begin
  # Try to include the rails initializer. If this isn't in a gem, this will fail.
  require 'initializer' unless REFINERY_ROOT == RAILS_ROOT # A Refinery gem install's Rails.root is not the REFINERY_ROOT.
rescue LoadError => load_error
end

module Refinery

  if defined? Rails::Configuration
    class Configuration < Rails::Configuration
      def default_plugin_paths
        paths = super.push(File.join(%W(#{REFINERY_ROOT} vendor plugins))).uniq
      end
    end
  end

  if defined? Rails::Plugin::Loader
    class PluginLoader < Rails::Plugin::Loader
      def add_plugin_load_paths
        super
        # add plugin lib paths to the $LOAD_PATH so that rake tasks etc. can be run when using a gem for refinery or gems for plugins.
        search_for = Regexp.new(File.join(%W(\( #{REFINERY_ROOT} vendor plugins \)? .+? lib)))
        paths = plugins.collect{ |plugin| plugin.load_paths }.flatten.reject{|path| path.scan(search_for).empty? or path.include?('/rails-') }
        paths = paths.reject{ |path| path.include?(REFINERY_ROOT) } if REFINERY_ROOT == Rails.root.to_s # superfluous when not in gem.
        ($refinery_gem_plugin_lib_paths = paths).each do |path|
          $LOAD_PATH.unshift path
        end
        $LOAD_PATH.uniq!
      end
    end
  end

  if defined? Rails::Initializer
    class Initializer < Rails::Initializer
      def self.run(command = :process, configuration = Configuration.new)
        Rails.configuration = configuration
        configuration.plugin_loader = Refinery::PluginLoader
        super
      end

      def load_plugins
        Refinery.add_gems
        super
      end
    end
  end

end