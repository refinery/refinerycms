module Refinery
  
  def self.add_gems    
    ActiveRecord::Base.module_eval do  	  
      begin
        require 'friendly_id'
        require 'will_paginate'
        require 'aasm'
      rescue LoadError => load_error
        # this will stop us running rake gems:install which we don't really want so just trap this error.
      end
  		
      # Stub has_friendly_id. This will get overriden when/if included.
      # The config will still complain that the gem is missing but this allows it to do so.
    	def self.has_friendly_id(column, options = {}, &block)
    	  super if defined? super and table_exists?
  	  end
  	end
  end
  
end