class <%= class_name %>Mailer < ActionMailer::Base

  def confirmation(<%= singular_name %>, request)
    subject     <%= class_name %>Setting.confirmation_subject
    recipients  <%= singular_name %>.email
    from        "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    reply_to    <%= class_name %>Setting.notification_recipients.split(',').first
    sent_on     Time.now
    @<%= singular_name %> =  <%= singular_name %>
  end

  def notification(<%= singular_name %>, request)
    subject     <%= class_name %>Setting.notification_subject
    recipients  <%= class_name %>Setting.notification_recipients
    from        "\"#{RefinerySetting[:site_name]}\" <no-reply@#{request.domain(RefinerySetting.find_or_set(:tld_length, 1))}>"
    sent_on     Time.now
    @<%= singular_name %> =  <%= singular_name %>
  end

end
