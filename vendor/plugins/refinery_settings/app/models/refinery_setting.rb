class RefinerySetting < ActiveRecord::Base
	class SettingNotFound < RuntimeError; end
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  serialize :value
  
  def title
    self.name.titleize
  end

	# internals
	
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
	
	def self.find_or_set(name, or_this_value)
	  setting_value = find_or_create_by_name(:name => name.to_s, :value => or_this_value).value
  end
	
	def self.[](name)
	  setting_value = find_by_name(name.to_s).value rescue nil
	end
	
	def self.[]=(name, value)
		setting = find_or_create_by_name(name.to_s)
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