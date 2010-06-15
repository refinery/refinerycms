class InquirySetting < ActiveRecord::Base

  def self.confirmation_body
    find_or_create_by_name("Confirmation Body")
  end

  def self.notification_recipients
    find_or_create_by_name("Notification Recipients")
  end

  def deletable?
    false
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

  def self.find_or_set(name, the_value)
    find_or_create_by_name(:name => name.to_s, :value => the_value).value
  end

  def self.[](name)
    setting = self.find_by_name(name.to_s)
    setting.value unless setting.nil?
  end

  def self.[]=(name, value)
    setting = find_or_create_by_name(name.to_s)
    setting.value = value
    setting.save
  end

end
