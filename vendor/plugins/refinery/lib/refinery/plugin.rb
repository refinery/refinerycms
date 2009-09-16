module Refinery
  class Plugin

    class << self
      
      def registered
        @registered_plugins ||= Refinery::Plugins.new
      end
      
      def active
        @active_plugins ||= Refinery::Plugins.new
      end
      
      def set_active(titles)
        active.clear
        titles.each do |title|
          active << registered[title] if registered[title]
        end
      end
      
      def register(&block)
        p = self.new
        yield p
      end
    
    end

    attr_accessor :title, :version, :description, :url, :menu_match, :plugin_activity, :directory, :hide_from_menu
    
    def initialize
      # add itself to the group of plugins
      self.class.registered << self
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