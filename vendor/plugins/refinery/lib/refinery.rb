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
  	end
  	
  	# Stub has_friendly_id unless it is already included.
  	# The config will still complain that the gem is missing but this allows it to do so.
    ActiveRecord::Base.class_eval do
  	  def self.has_friendly_id(column, options = {}, &block)
	    end
	  end unless ActiveRecord::Base.methods.include? 'has_friendly_id'
  end
  
end