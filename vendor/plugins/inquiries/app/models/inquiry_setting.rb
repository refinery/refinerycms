class InquirySetting < ActiveRecord::Base
  
  def self.confirmation_body
    find_by_name("Confirmation Body")
  end

  def self.notification_recipients
    find_by_name("Notification Recipients")
  end
  
end