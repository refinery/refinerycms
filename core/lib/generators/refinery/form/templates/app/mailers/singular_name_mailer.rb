class Refinery_<%= namespacing %><%= class_name %>Mailer < ActionMailer::Base

  def confirmation(<%= singular_name %>, request)
    subject     Refinery_<%= namespacing %><%= class_name %>::Setting.confirmation_subject
    recipients  <%= singular_name %>.email
    from        "\"#{Refinery::Core.site_name}\" <no-reply@#{request.domain}>"
    reply_to    Refinery_<%= namespacing %><%= class_name %>::Setting.notification_recipients.split(',').first
    sent_on     Time.now
    @<%= singular_name %> =  <%= singular_name %>
  end

  def notification(<%= singular_name %>, request)
    subject     Refinery_<%= namespacing %><%= class_name %>::Setting.notification_subject
    recipients  Refinery_<%= namespacing %><%= class_name %>::Setting.notification_recipients
    from        "\"#{Refinery::Core.site_name}\" <no-reply@#{request.domain}>"
    sent_on     Time.now
    @<%= singular_name %> =  <%= singular_name %>
  end

end
