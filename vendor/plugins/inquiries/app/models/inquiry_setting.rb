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

end
