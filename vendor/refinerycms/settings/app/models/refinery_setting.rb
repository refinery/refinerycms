class RefinerySetting < ActiveRecord::Base

  validates :name, :presence => true

  serialize :value # stores into YAML format
  serialize :callback_proc_as_string

  # Docs for acts_as_indexed http://github.com/dougal/acts_as_indexed
  acts_as_indexed :fields => [:name]

  before_save do |setting|
    setting.restricted = false if setting.restricted.nil?
  end

  after_save do |setting|
    setting.class.rewrite_cache
  end

  class << self
    # Number of settings to show per page when using will_paginate
    def per_page
      12
    end

    def ensure_cache_exists!
      if (result = Rails.cache.read(self.cache_key)).nil?
        result = rewrite_cache
      end

      result
    end
    protected :ensure_cache_exists!

    def cache_read(name = nil, scoping = nil)
      result = ensure_cache_exists!

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
      # delete cache
      Rails.cache.delete(self.cache_key)

      # generate new cache
      result = self.to_cache(RefinerySetting.all)

      # write cache
      Rails.cache.write(self.cache_key, result)

      # return cache
      result
    end

    def cache_key
      "#{Refinery.base_cache_key}_refinery_settings_cache"
    end

    # find_or_set offers a convenient way to
    def find_or_set(name, the_value, options={})
      options = {:scoping => nil, :restricted => false, :callback_proc_as_string => nil}.merge(options)
      # Try to get the value from cache first.
      scoping = options[:scoping]
      restricted = options[:restricted]
      callback_proc_as_string = options[:callback_proc_as_string]

      # try to find the setting first
      value = cache_read(name, scoping)

      # if the setting's value is nil, store a new one using the existing functionality.
      value = set(name, options.merge({:value => the_value})) if value.nil?

      # Return what we found.
      value
    end

    alias :get_or_set :find_or_set

    # Retrieve the current value for the setting whose name is supplied.
    def get(name)
      cache_read(name)
    end

    alias :[] :get

    def set(name, value)
      scoping = (value.is_a?(Hash) and value.has_key?(:scoping)) ? value[:scoping] : nil
      setting = find_or_initialize_by_name_and_scoping(:name => name.to_s, :scoping => scoping)

      # you could also pass in {:value => 'something', :scoping => 'somewhere'}
      unless value.is_a?(Hash) and value.has_key?(:value)
        setting.value = value
      else
        setting.value = value[:value]
        setting.scoping = value[:scoping] if value.has_key?(:scoping)
        setting.callback_proc_as_string = value[:callback_proc_as_string] if value.has_key?(:callback_proc_as_string)
        setting.destroyable = value[:destroyable] if value.has_key?(:destroyable)
      end

      # Save because we're in a setter method.
      setting.save

      # Return the value
      setting.value
    end

    # DEPRECATED for removal at >= 0.9.9
    def []=(name, value)
      warning = ["\n*** DEPRECATION WARNING ***"]
      warning << "You should not use this anymore: RefinerySetting[#{name.inspect}] = #{value.inspect}."
      warning << "\nInstead, you should use RefinerySetting.set(#{name.inspect}, #{value.inspect})"
      warning << ""
      warning << "Called from: #{caller.first.inspect}\n\n"
      $stdout.puts warning.join("\n")

      set(name, value)
    end
  end

  # prettier version of the name.
  # site_name becomes Site Name
  def title
    self.name.titleize
  end

  # form_value is so that on the web interface we can display a sane value.
  def form_value
    unless self[:value].blank? or self[:value].is_a?(String)
      YAML::dump(self[:value])
    else
      self[:value]
    end
  end

  def value
    replacements!(self[:value])
  end

  def value=(new_value)
    # must convert to string if true or false supplied otherwise it becomes 0 or 1, unfortunately.
    if %w(trueclass falseclass).include?(new_value.class.to_s.downcase)
      new_value = new_value.to_s
    end

    super
  end

  def callback_proc
    eval("Proc.new{#{self.callback_proc_as_string} }") if self.callback_proc_as_string.present?
  end

private
  # Below is not very nice, but seems to be required. The problem is when Rails
  # serialises a fields like booleans it doesn't retrieve it back out as a boolean
  # it just returns a string. This code maps the two boolean values
  # correctly so that a boolean is returned instead of a string.
  REPLACEMENTS = {"true" => true, "false" => false}

  def replacements!(current_value)
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

    current_value
  end

end
