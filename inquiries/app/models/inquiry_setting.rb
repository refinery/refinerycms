class InquirySetting < ActiveRecord::Base

  def self.confirmation_body
    find_or_create_by_name( :name => "Confirmation Body",
                            :value => "Thank you for your inquiry %name%,\n\nThis email is a receipt to confirm we have received your inquiry and we'll be in touch shortly.\n\nThanks.",
                           :destroyable => false)
  end

  def self.confirmation_subject
    find_or_create_by_name( :name => "Confirmation Subject",
                            :value => "Thank you for your inquiry",
                            :destroyable => false)
  end

  def self.notification_recipients
    find_or_create_by_name( :name => "Notification Recipients",
                            :destroyable => false)
  end

  def self.notification_subject
    find_or_create_by_name( :name => "Notification Subject",
                            :value => "New inquiry from your website",
                            :destroyable => false)
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
