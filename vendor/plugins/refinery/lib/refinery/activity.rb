module Refinery
  class Activity
  
    attr_accessor :class, :title, :url_prefix, :order, :conditions, :limit, :created_image, :updated_image, :conditions
  
    def initialize(new_options)
      options = {:class => nil, :title => nil, :url_prefix => "", :order => 'updated_at DESC', :conditions => nil, :limit => 10, :created_image => "add.png", :updated_image => "edit.png"}
      options.merge!(new_options).each { |key,value| eval("self.#{key} = value") }
    end
    
    def url_prefix
      "#{@url_prefix}_".gsub("__", "_") unless @url_prefix.blank?
    end
  
  end
end