class RefinerySetting < ActiveRecord::Base

  validates_presence_of :name

  serialize :value # stores into YAML format
  serialize :callback_proc_as_string

  # Number of settings to show per page when using will_paginate
  def self.per_page
    12
  end

  before_save :check_restriction

  after_save do |setting|
    if self.column_names.include?('scoping')
      cache_write(setting.name, setting.scoping.presence, setting.value)
    else
      cache_write(setting.name, nil, setting.value)
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
    scoping = options[:scoping]
    restricted = options[:restricted]
    callback_proc_as_string = options[:callback_proc_as_string]
    if (value = cache_read(name, scoping)).nil?
      setting = find_or_create_by_name(:name => name.to_s, :value => the_value)

      # if the database is not up to date yet then it won't know about certain fields.
      setting.scoping = scoping if self.column_names.include?('scoping')
      setting.restricted = restricted if self.column_names.include?('restricted')
      if callback_proc_as_string.is_a?(String) and self.column_names.include?('callback_proc_as_string')
        setting.callback_proc_as_string = callback_proc_as_string
      end

      setting.save

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
    setting = find_or_create_by_name(name.to_s)

    scoping = nil
    # you could also pass in {:value => 'something', :scoping => 'somewhere'}
    unless value.is_a?(Hash) and value.has_key?(:value)
      setting.value = value
    else
      setting.value = value[:value]
      if value.has_key?(:scoping) and setting.class.column_names.include?('scoping')
        scoping, setting.scoping = value[:scoping]
      end
      if value.has_key?(:callback_proc_as_string) and
         setting.class.column_names.include?('callback_proc_as_string')
        setting.callback_proc_as_string = value[:callback_proc_as_string]
      end
    end

    setting.save
    cache_write(setting.name, scoping, setting.value)
  end

  # Below is not very nice, but seems to be required. The problem is when Rails
  # serialises a fields like booleans it doesn't retrieve it back out as a boolean
  # it just returns a string. This code maps the two boolean values
  # correctly so that a boolean is returned instead of a string.
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
    if ["trueclass","falseclass"].include?(new_value.class.to_s.downcase)
      new_value = new_value.to_s
    end
    self[:value] = new_value
  end

  def callback_proc
    if RefinerySetting.column_names.include?('callback_proc_as_string') and
       self.callback_proc_as_string.present?
      eval "Proc.new{#{self.callback_proc_as_string} }"
    end
  end

  private

  def check_restriction
    if self.class.column_names.include?('restricted') and restricted.nil?
      self.restricted = false
    end
  end

end
