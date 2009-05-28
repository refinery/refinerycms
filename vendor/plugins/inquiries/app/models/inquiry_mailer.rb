class InquiryMailer < ActionMailer::Base

  def confirmation(inquiry, request)
    @subject = "Thank you for your inquiry"
    @recipients = inquiry.email
    @from = "#{RefinerySetting[:site_name]} <no-reply@#{request.domain(RefinerySetting[:tld_length] ||= 1)}>"
    @sent_on = Time.now
    @body[:inquiry] = inquiry
  end

  def notification(inquiry, request)
    @subject = "New inquiry from your website"
    @recipients = InquirySetting.notification_recipients.value
    @from = "#{RefinerySetting[:site_name]} <no-reply@#{request.domain(RefinerySetting[:tld_length] ||= 1)}>"
    @sent_on = Time.now
    @body[:inquiry] = inquiry
  end

end