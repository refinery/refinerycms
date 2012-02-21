module Refinery
  module <%= class_name.pluralize %>
    class Setting < Refinery::Core::BaseModel

      def self.confirmation_body
        Refinery::Setting.find_or_set(:<%= singular_name %>_confirmation_body,
          "Thank you for your <%= singular_name.humanize.downcase %> %name%,\n\nThis email is a receipt to confirm we have received your <%= singular_name.humanize.downcase %> and we'll be in touch shortly.\n\nThanks."
        )
      end

      def self.confirmation_subject
        Refinery::Setting.find_or_set(:<%= singular_name %>_confirmation_subject,
                                    "Thank you for your <%= singular_name.humanize.downcase %>")
      end

      def self.confirmation_subject=(value)
        # handles a change in Refinery API
        Refinery::Setting.set(:<%= singular_name %>_confirmation_subject, value)
      end

      def self.notification_recipients
        Refinery::Setting.find_or_set(:<%= singular_name %>_notification_recipients,
                                    ((Role[:refinery].users.first.email rescue nil) if defined?(Role)).to_s)
      end

      def self.notification_subject
        Refinery::Setting.find_or_set(:<%= singular_name %>_notification_subject,
                                    "New <%= singular_name.humanize.downcase %> from your website")
      end

    end
  end
end
