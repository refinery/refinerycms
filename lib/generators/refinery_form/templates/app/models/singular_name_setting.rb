class <%= class_name %>Setting < ActiveRecord::Base

  def self.confirmation_body
    RefinerySetting.find_or_set(:<%= singular_name %>_confirmation_body,
      "Thank you for your <%= singular_name.humanize.downcase %> %name%,\n\nThis email is a receipt to confirm we have received your <%= singular_name.humanize.downcase %> and we'll be in touch shortly.\n\nThanks."
    )
  end

  def self.confirmation_subject
    RefinerySetting.find_or_set(:<%= singular_name %>_confirmation_subject,
                                "Thank you for your <%= singular_name.humanize.downcase %>")
  end

  def self.confirmation_subject=(value)
    # handles a change in Refinery API
    if RefinerySetting.methods.map(&:to_sym).include?(:set)
      RefinerySetting.set(:<%= singular_name %>_confirmation_subject, value)
    else
      RefinerySetting[:<%= singular_name %>_confirmation_subject] = value
    end
  end

  def self.notification_recipients
    RefinerySetting.find_or_set(:<%= singular_name %>_notification_recipients,
                                ((Role[:refinery].users.first.email rescue nil) if defined?(Role)).to_s)
  end

  def self.notification_subject
    RefinerySetting.find_or_set(:<%= singular_name %>_notification_subject,
                                "New <%= singular_name.humanize.downcase %> from your website")
  end

end
