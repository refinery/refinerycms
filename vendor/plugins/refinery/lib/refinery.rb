module Refinery
  ActiveRecord::Base.module_eval do
		begin
			require 'friendly_id'
			require 'will_paginate'
			require 'aasm'
		rescue LoadError => load_error
			# this will stop us running rake gems:install which we don't really want so just trap this error.
		end
	end
end