class InquiryMailer < ActionMailer::Base

  def confirmation(inquiry, request)
    subject     InquirySetting.confirmation_subject.value
    recipients  inquiry.email
    from        "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    reply_to    InquirySetting.notification_recipients.value.split(',').first
    sent_on     Time.now
    body        :inquiry => inquiry
  end

  def notification(inquiry, request)
    subject     InquirySetting.notification_subject.value
    recipients  InquirySetting.notification_recipients.value
    from        "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    sent_on     Time.now
    body        :inquiry => inquiry
  end

end
