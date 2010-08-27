class RefinerySetting < ActiveRecord::Base

  validates :name, :presence => true

  serialize :value # stores into YAML format
  serialize :callback_proc_as_string

  before_save :check_restriction

  after_save do |setting|
    setting.class.rewrite_cache
  end

  class << self
    # Number of settings to show per page when using will_paginate
    def per_page
      12
    end

    def cache_read(name = nil, scoping = nil)
      if (result = Rails.cache.read(self.cache_key)).nil?
        result = rewrite_cache
      end

      if name.present?
        result = result.detect do |rs|
          rs[:name] == name.to_s.downcase.to_sym and rs[:scoping] == scoping
        end
        result = result[:value] if !result.nil? and result.keys.include?(:value)
      end

      result
    end

    def to_cache(settings)
      settings.collect do |rs|
        {
          :name => rs.name.to_s.downcase.to_sym,
          :value => rs.value,
          :scoping => rs.scoping,
          :destroyable => rs.destroyable
        }
      end
    end

    def rewrite_cache
      Rails.cache.delete(self.cache_key)
      Rails.cache.write(self.cache_key, (result = self.to_cache(RefinerySetting.all)))
      result
    end

    def cache_key
      "#{Refinery.base_cache_key}_refinery_settings_cache"
    end

    # Access method that allows dot notation to work.
    # Say you had a setting called "site_name". You could access that by going RefinerySetting[:site_name]
    # but with this you can also access that by going RefinerySettting.site_name
    def method_missing(method, *args)
      method_name = method.to_s
      super(method, *args)

    rescue NoMethodError
      if method_name =~ /=$/
        self[method_name.gsub('=', '')] = args.first
      else
        self[method_name]
      end
    end

    def find_or_set(name, the_value, options={})
      # Try to get the value from cache first.
      scoping = options[:scoping]
      restricted = options[:restricted]
      callback_proc_as_string = options[:callback_proc_as_string]
      if (value = cache_read(name, scoping)).nil?
        setting = find_or_create_by_name(:name => name.to_s, :value => (value = the_value))

        # if the database is not up to date yet then it won't know about certain fields.
        setting.scoping = scoping
        setting.restricted = restricted
        if callback_proc_as_string.is_a?(String)
          setting.callback_proc_as_string = callback_proc_as_string
        end

        setting.save
      end

      # Return what we found.
      value
    end

    def [](name)
      cache_read(name)
    end

    def []=(name, value)
      setting = find_or_initialize_by_name(name.to_s)

      scoping = nil
      # you could also pass in {:value => 'something', :scoping => 'somewhere'}
      unless value.is_a?(Hash) and value.has_key?(:value)
        setting.value = value
      else
        setting.value = value[:value]
        setting.scoping = value[:scoping] if value.has_key?(:scoping)
        setting.callback_proc_as_string = value[:callback_proc_as_string] if value.has_key?(:callback_proc_as_string)
        setting.destroyable = value[:destroyable] if value.has_key?(:destroyable)
      end

      setting.save
      setting.value
    end
  end

  # prettier version of the name.
  # site_name becomes Site Name
  def title
    self.name.titleize
  end

  def form_value
    unless self[:value].blank? or self[:value].is_a?(String)
      YAML::dump(self[:value])
    else
      self[:value]
    end
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

    current_value
  end

  def value=(new_value)
    # must convert to string if true or false supplied otherwise it becomes 0 or 1, unfortunately.
    new_value = new_value.to_s if %w(trueclass falseclass).include?(new_value.class.to_s.downcase)

    self[:value] = new_value
  end

  def callback_proc
    eval("Proc.new{#{self.callback_proc_as_string} }") if self.callback_proc_as_string.present?
  end

  private

  def check_restriction
    self.restricted = false if restricted.nil?
  end

end
