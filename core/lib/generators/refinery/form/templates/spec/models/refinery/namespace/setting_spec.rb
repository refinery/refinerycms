require 'spec_helper'

module Refinery
  module <%= namespacing %>
    describe Setting, :type => :model do
      describe ".confirmation_message=" do
        it "delegates to Refinery::Setting#set" do
          expect(Refinery::Setting).to receive(:set).
            with(:<%= singular_name %>_confirmation_message, "some value")

          Refinery::<%= namespacing %>::Setting.confirmation_message = "some value"
        end
      end

      describe ".confirmation_subject=" do
        it "delegates to Refinery::Setting#set" do
          expect(Refinery::Setting).to receive(:set).
            with(:<%= singular_name %>_confirmation_subject, "some value")

          Refinery::<%= namespacing %>::Setting.confirmation_subject = "some value"
        end
      end

      describe ".notification_recipients=" do
        it "delegates to Refinery::Setting#set" do
          expect(Refinery::Setting).to receive(:set).
            with(:<%= singular_name %>_notification_recipients, "some value")

          Refinery::<%= namespacing %>::Setting.notification_recipients = "some value"
        end
      end
    end
  end
end
