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

  def self.find_or_set(name, or_this_value)
    setting_value = find_or_create_by_name(:name => name.to_s, :value => or_this_value).value
  end

  def self.[](name)
    self.find_by_name(name.to_s).value rescue nil
  end

  def self.[]=(name, value)
    setting = find_or_create_by_name(name.to_s)
    setting.value = value
    setting.save!
  end

  REPLACEMENTS = {"true" => true, "false" => false}

  def value
    _value = self[:value]

   unless _value.nil?
      REPLACEMENTS.each do |current_value, new_value|
        _value = new_value if _value == current_value
      end
      _value = _value.to_i if _value.to_i.to_s == _value rescue _value
    end

    return _value
  end

  def value=(new_value)
    # must convert to string if true or false supplied otherwise it becomes 0 or 1, unfortunately.
    new_value = new_value.to_s if ["trueclass","falseclass"].include?(new_value.class.to_s.downcase)
    self[:value] = new_value
  end

  def self.per_page
    10
  end

end
