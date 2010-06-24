class RefinerySetting < ActiveRecord::Base

  validates_presence_of :name

  serialize :value # stores into YAML format

  # Number of settings to show per page when using will_paginate
  def self.per_page
    12
  end

  after_save do |setting|
    clazz = setting.class
    if clazz.column_names.include?('scoping')
      cache_write(setting.name, setting.scoping.presence, setting.value)
    else
      clazz.cache_write(setting.name, nil, setting.value)
    end
  end

  def self.cache_key(name, scoping)
    "#{Refinery.base_cache_key}_refinery_setting_#{name}#{"_with_scoping_#{scoping}" if scoping.present?}"
  end

  def self.cache_read(name, scoping)
    Rails.cache.read(cache_key(name, scoping))
  end

  def self.cache_write(name, scoping, value)
    Rails.cache.write(cache_key(name, scoping), value)
  end

  # prettier version of the name.
  # site_name becomes Site Name
  def title
    self.name.titleize
  end

  # Access method that allows dot notation to work.
  # Say you had a setting called "site_name". You could access that by going RefinerySetting[:site_name]
  # but with this you can also access that by going RefinerySettting.site_name
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

  def self.find_or_set(name, the_value, options={})
    # Try to get the value from cache first.
    scoping = (options = {:scoping => nil}.merge(options))[:scoping]
    if (value = cache_read(name, scoping)).nil?
      # if the database is not up to date yet then it won't know about scoping..
      if self.column_names.include?('scoping')
        setting = find_or_create_by_name_and_scoping(:name => name.to_s, :value => the_value, :scoping => scoping)
      else
        setting = find_or_create_by_name(:name => name.to_s, :value => the_value)
      end

      # cache whatever we found including its scope in the name, even if it's nil.
      cache_write(name, scoping, (value = setting.try(:value)))
    end

    # Return what we found.
    value
  end

  def self.[](name)
    # Try to get the value from cache first.
    if (value = cache_read(name, (scoping = nil))).nil?
      # Not found in cache, try to find the record itself and cache whatever we find.
      value = cache_write(name, scoping, self.find_by_name(name.to_s).try(:value))
    end

    # Return what we found.
    value
  end

  def self.[]=(name, value)
<<<<<<< HEAD:vendor/engines/refinery_settings/app/models/refinery_setting.rb
    setting = find_or_initialize_by_name(name.to_s)
    setting.value = value
=======
    setting = find_or_create_by_name(name.to_s)
    
    # you could also pass in {:value => 'something', :scoping => 'somewhere'}
    unless value.is_a?(Hash) && value.has_key?(:value) && value.has_key?(:scoping)
      setting.value = value
    else
      setting.value = value[:value]
      setting.scoping = value[:scoping]
    end
    
>>>>>>> master:vendor/plugins/refinery_settings/app/models/refinery_setting.rb
    setting.save
  end

  # Below is not very nice, but seems to be required
  # The problem is when Rails serialises a fields like booleans it doesn't retrieve it back out as a boolean
  # it just returns a string. This code maps the two boolean values correctly so a boolean is returned
  REPLACEMENTS = {"true" => true, "false" => false}

  def value
    unless (current_value = self[:value]).nil?
      # This bit handles true and false so that true and false are actually returned
      # not "0" and "1"
      REPLACEMENTS.each do |current, new_value|
        current_value = new_value if current_value == current
      end

      # converts the serialised value back to an integer
      # if the value is an integer
      begin
        if current_value.to_i.to_s == current_value
          current_value = current_value.to_i
        end
      rescue
        current_value
      end
    end

    return current_value
  end

  def value=(new_value)
    # must convert to string if true or false supplied otherwise it becomes 0 or 1, unfortunately.
    new_value = new_value.to_s if ["trueclass","falseclass"].include?(new_value.class.to_s.downcase)
    self[:value] = new_value
  end

end
