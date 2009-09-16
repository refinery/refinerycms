module Refinery
  class Plugin

		def self.register(&block)
		  yield self.new
		end

    attr_accessor :title, :version, :description, :url, :menu_match, :plugin_activity, :directory, :hide_from_menu, :always_allow_access
    
    def initialize
      Refinery::Plugins.registered << self # add me to the collection of registered plugins
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
	
		def always_allow_access
			@always_allow_access ||= false
		end
  
  end
end