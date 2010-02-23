if Refinery.is_a_gem
  begin
    # Try to include the rails initializer. If this isn't in a gem, this will fail.
    require 'initializer'
  rescue LoadError => load_error
    # we don't need to do anything.
    puts "*** RefineryCMS gem load failed, attempting to load traditionally... ***"
  end
end

module Refinery

  if defined? Rails::Configuration
    class Configuration < Rails::Configuration
      def default_plugin_paths
        paths = super.push(Refinery.root.join("vendor", "plugins")).uniq
      end
    end
  end

  if defined? Rails::Plugin::Loader
    class PluginLoader < Rails::Plugin::Loader
      def add_plugin_load_paths
        super
        # add plugin lib paths to the $LOAD_PATH so that rake tasks etc. can be run when using a gem for refinery or gems for plugins.
        search_for = Regexp.new(File.join(%W(\( #{Refinery.root.join("vendor", "plugins")} \)? .+? lib)))
        paths = plugins.collect{ |plugin| plugin.load_paths }.flatten.reject{|path| path.scan(search_for).empty? or path.include?('/rails-') }
        paths = paths.reject{ |path| path.include?(Refinery.root.to_s) } unless Refinery.is_a_gem
        paths.uniq!
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
        configuration.plugin_loader = Refinery::PluginLoader
        Rails.configuration = configuration
        super
      end
    end
  end

end