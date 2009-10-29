module Refinery
  class Plugins < Array
  
    def initialize
      @plugins = []
    end

    def find_by_title(title)
      self.reject { |plugin| plugin.title != title }.first
    end

    def find_by_model(model)
      self.reject { |plugin| plugin.activity.reject {|activity| activity.class != model }.empty? }.first
    end

    def find_activity_by_model(model)
      plugin = find_by_model(model)
      plugin.activity.reject {|activity| activity.class != model}.first unless plugin.nil?
    end

    def [](title)
      self.find { |plugin| plugin.title == title }
    end

    def self.registered
      @registered_plugins ||= self.new
    end

    def titles
      self.collect { |p| p.title }
    end

    def in_menu
      self.reject{ |p| p.hide_from_menu }
    end

    def self.active
      @active_plugins ||= self.new
    end

    def self.always_allowed
      registered.reject { |p| !p.always_allow_access }
    end

    def self.set_active(titles)
      active.clear
      titles.each do |title|
        active << registered[title] if registered[title]
      end
    end

  end
end