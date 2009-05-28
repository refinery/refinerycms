module Refinery
  class Plugins < Array
  
    attr_accessor :plugins
  
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
  
  end
end