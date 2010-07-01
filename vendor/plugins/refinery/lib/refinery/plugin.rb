module Refinery
  class Plugin

    def self.register(&block)
      yield (new_plugin = self.new)
    end

    attr_accessor :name, :title, :version, :description, :url, :menu_match, :plugin_activity, :directory, :hide_from_menu, :always_allow_access,
                  :pathname, :dashboard

    def initialize
      # save the pathname to where this plugin is.
      self.pathname = (Pathname.new(self.directory.present? ? self.directory : caller(3).first.split('/rails').first) rescue nil)
      Refinery::Plugins.registered << self # add me to the collection of registered plugins
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

    def always_allow_access
      @always_allow_access ||= false
    end

    def name
      # we have to use @title not def title because def title translates based on name (circular reference)
      @name ||= @title.to_s.downcase.gsub(' ', '_')
    end

    def dashboard?
      @dashboard ||= false
    end

    def title
      ::I18n.translate("plugins.#{name}.title", :default => @title)
    end

    def highlighted?(params)
      (params[:controller] =~ self.menu_match) or (self.dashboard? and params[:action] == 'error_404')
    end

    def menu_match
      @menu_match ||= /(admin|refinery)\/#{self.name}$/
    end

    def url
      @url ||= {:controller => "/refinery/#{self.directory.blank? ? self.title.gsub(" ", "_").downcase : self.directory.split('/').pop}"}
    end

  end
end
