module Refinery
  module <%= namespacing %>
    class <%= class_name %>Mailer < ActionMailer::Base

      def confirmation(<%= singular_name %>, request)
        @<%= singular_name %> = <%= singular_name %>
        mail :subject  => Refinery::<%= namespacing %>::Setting.confirmation_subject,
             :to       => <%= singular_name %>.email,
             :from     => "\"#{Refinery::Core.site_name}\" <no-reply@#{request.domain}>",
             :reply_to => Refinery::<%= namespacing %>::Setting.notification_recipients.split(',').first
      end

      def notification(<%= singular_name %>, request)
        @<%= singular_name %> = <%= singular_name %>
        mail :subject  => Refinery::<%= namespacing %>::Setting.notification_subject,
             :to       => Refinery::<%= namespacing %>::Setting.notification_recipients,
             :from     => "\"#{Refinery::Core.site_name}\" <no-reply@#{request.domain}>"
      end

    end
  end
end