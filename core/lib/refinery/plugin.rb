module Refinery
  class Plugin

    attr_accessor :name, :class_name, :controller, :directory, :url,
                  :always_allow_access, :menu_match, :hide_from_menu,
                  :pathname

    def self.register(&_block)
      yield(plugin = new)

      raise ArgumentError, "A plugin MUST have a name!: #{plugin.inspect}" if plugin.name.blank?

      # Set defaults.
      plugin.menu_match ||= %r{refinery/#{plugin.name}(/.+?)?$}
      plugin.always_allow_access ||= false
      plugin.class_name ||= plugin.name.camelize

      # add the new plugin to the collection of registered plugins
      ::Refinery::Plugins.registered.unshift(plugin).uniq!(&:name)
    end

    # Returns the internationalized version of the title
    def title
      ::I18n.translate(['refinery', 'plugins', name, 'title'].join('.'))
    end

    # Returns the internationalized version of the description
    def description
      ::I18n.translate(['refinery', 'plugins', name, 'description'].join('.'))
    end

    # Used to highlight the current tab in the admin interface
    def highlighted?(params)
      !!(params[:controller].try(:gsub, "admin/", "") =~ menu_match)
    end

    def pathname=(value)
      value = Pathname.new(value) if value.is_a? String
      @pathname = value
    end

    def landable?
      !hide_from_menu && url.present?
    end

    # Returns a hash that can be used to create a url that points to the administration part of the plugin.
    def url
      @url ||= build_url

      if @url.is_a?(Hash)
        { only_path: true }.merge(@url)
      elsif @url.respond_to?(:call)
        @url.call
      else
        @url
      end
    end

    def initialize
      # provide a default pathname to where this plugin is using its lib directory.
      depth = 4
      self.pathname ||= Pathname.new(caller(depth).first.match("(.*)#{File::SEPARATOR}lib")[1])
    end

    private

    def build_url
      action = controller.presence ||
               directory.to_s.split('/').pop.presence ||
               name

      { controller: "refinery/admin/#{action}" }
    end
  end
end
