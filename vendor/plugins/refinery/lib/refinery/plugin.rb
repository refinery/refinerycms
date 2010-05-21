module Refinery
  class Plugin

    def self.register(&block)
      yield (new_plugin = self.new)
      if defined?(Page) && new_plugin.title
        # Prevent page slugs from being this plugin's controller name
        Page.friendly_id_config.reserved_words << new_plugin.title.gsub(" ", "_").downcase
      end
    end

    attr_accessor :title, :version, :description, :url, :menu_match, :plugin_activity, :directory, :hide_from_menu, :always_allow_access

    def initialize
      Refinery::Plugins.registered << self # add me to the collection of registered plugins
    end

    def highlighted?(params)
      params[:controller] =~ self.menu_match
    end

    def activity
      self.plugin_activity ||= []
    end

    def activity=(activities)
      [activities].flatten.each { |activity| add_activity(activity) }
    end

    def add_activity(options)
      (self.plugin_activity ||= []) << Activity::new(options)
    end

    def url
      @url ||= {:controller => "/refinery/#{self.directory.blank? ? self.title.gsub(" ", "_").downcase : self.directory.split('/').pop}"}
    end

    def menu_match
      @menu_match ||= /admin\/#{self.title.gsub(" ", "_").downcase}$/
    end

    def hide_from_menu
      @hide_from_menu
    end

    def always_allow_access
      @always_allow_access ||= false
    end

  end
end
