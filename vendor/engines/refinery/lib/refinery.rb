module Refinery

  autoload :Plugin,  'refinery/plugin'
  autoload :Plugins, 'refinery/plugins'
  autoload :Activity, 'refinery/activity'

  class << self
    attr_accessor :is_a_gem, :root, :s3_backend, :base_cache_key
    def is_a_gem
      @is_a_gem ||= false
    end

    def root
      @root ||= Pathname.new(File.dirname(__FILE__).split("vendor").first.to_s)
    end

    def s3_backend
      @s3_backend ||= false
    end

    def base_cache_key
      @base_cache_key ||= "refinery"
    end

    def version
      ::Refinery::Version.to_s
    end
  end

  class Version
    MAJOR = 0
    MINOR = 9
    TINY = 7
    BUILD = 'dev'

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join('.')

    def self.to_s
      STRING
    end
  end

end

Refinery::Plugin.register do |plugin|
  plugin.title = "Refinery"
  plugin.name = "refinery_core"
  plugin.description = "Core refinery plugin"
  plugin.version = 1.0
  plugin.hide_from_menu = true
  plugin.always_allow_access = true
  plugin.menu_match = /(refinery|admin)\/(refinery_core|base)$/
  # this tells refinery where this plugin is located on the filesystem and helps with urls.
  # plugin.directory = directory
end
require_dependency 'refinery/form_helpers'
require_dependency 'refinery/base_presenter'

[ Refinery.root.join("vendor", "plugins", "*", "app", "presenters").to_s,
  Refinery.root.join("app", "presenters").to_s
].uniq.each do |path|
  Dir[path].each do |presenters_path|
    $LOAD_PATH << presenters_path
    ::ActiveSupport::Dependencies.load_paths << presenters_path
  end
end
