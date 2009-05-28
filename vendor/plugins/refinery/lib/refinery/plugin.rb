module Refinery
  class Plugin

    attr_accessor :title, :version, :description, :url, :menu_match, :plugin_activity, :directory, :hide_from_menu

    def initialize
      # add itself to the group of plugins
      ($plugins ||= Plugins::new) << self
    end

    def highlighted?(params)
      params[:controller] =~ menu_match
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
  		@url ||= "/admin/#{self.directory.blank? ? self.title.downcase : self.directory.split('/').pop}"
  	end
	
  	def menu_match
  		@menu_match ||= /admin\/#{self.title.downcase}/
  	end
  	
  	def hide_from_menu
  	  @hide_from_menu
	  end
  
  end
end