module Refinery
  class Plugin

    def self.register(&block)
      yield self.new
    end

    attr_accessor :name, :title, :version, :description, :url, :menu_match, :plugin_activity, :directory, :hide_from_menu, :always_allow_access

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
      @url ||= {:controller => "admin/#{self.directory.blank? ? self.title.gsub(" ", "_").downcase : self.directory.split('/').pop}"}
    end

    def menu_match
      @menu_match ||= /#{self.name.gsub(/^\//, "")}$/
    end

    def name
      @name ||= self.title.gsub(" ", "_").downcase
    end

    def always_allow_access
      @always_allow_access ||= false
    end

  end
end
