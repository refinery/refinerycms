class <%= class_name %>Mailer < ActionMailer::Base

  def confirmation(<%= singular_name %>, request)
    subject     <%= class_name %>::Setting.confirmation_subject
    recipients  <%= singular_name %>.email
    from        "\"#{t('site_name', :scope => 'refinery.core.config')}\" <no-reply@#{request.domain}>"
    reply_to    <%= class_name %>::Setting.notification_recipients.split(',').first
    sent_on     Time.now
    @<%= singular_name %> =  <%= singular_name %>
  end

  def notification(<%= singular_name %>, request)
    subject     <%= class_name %>::Setting.notification_subject
    recipients  <%= class_name %>::Setting.notification_recipients
    from        "\"#{t('site_name', :scope => 'refinery.core.config')}\" <no-reply@#{request.domain}>"
    sent_on     Time.now
    @<%= singular_name %> =  <%= singular_name %>
  end

end
