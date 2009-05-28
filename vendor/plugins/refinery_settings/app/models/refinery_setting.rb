class RefinerySetting < ActiveRecord::Base
	class SettingNotFound < RuntimeError; end
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def title
    self.name.titleize
  end

	# internals
	
	cattr_accessor :defaults
	@@refinery_settings_defaults = {}.with_indifferent_access
	
	def self.method_missing(method, *args)
		method_name = method.to_s
		super(method, *args)
		
	rescue NoMethodError
		if method_name =~ /=$/
			self[method_name.gsub('=', '')] = args.first
		else
			self[method_name]
		end
	end
	
	def self.all
		settings = {}
		find(:all).each do |setting|
			settings[setting.name] = setting.value
		end
		settings.with_indifferent_access
	end
	
	def self.[](name)
		if setting = find_by_name(name.to_s)
			setting.value
		elsif @@refinery_settings_defaults[name.to_s]
			@@refinery_settings_defaults[name.to_s]
		else
			nil
		end
	end
	
	def self.[]=(name, value)
		setting = find_by_name(name.to_s) || new(:name => name.to_s)
		setting.value = value
		setting.save!
	end
	
	def value
	  begin
		  eval(self[:value])
  	rescue
  	  self[:value]
    end
	end
	
	def value=(new_value)
	  # must convert to string if true or false supplied otherwise it becomes 0 or 1, unfortunately.
	  new_value = new_value.to_s if ["trueclass","falseclass"].include?(new_value.class.to_s.downcase)
		self[:value] = new_value
	end

end