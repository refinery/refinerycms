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

end
