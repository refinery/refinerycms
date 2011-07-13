require "spec_helper"

require File.expand_path("../../../features/support/factories", __FILE__)

module Refinery
  module Users
    describe "password recovery form" do
      let(:user) { Factory(:user, :email => "refinery@refinerycms.com") }

      it "asks user to specify email address" do
        visit new_refinery_user_session_url
        click_link "I forgot my password"
        has_content?("Please enter the email address for your account.").should be_true
      end

      context "when existing email specified" do
        it "shows success message" do
          visit new_refinery_user_password_url
          fill_in "refinery_user_email", :with => user.email
          click_button "Reset password"
          has_content?("An email has been sent to you with a link to reset your password.").should be_true
        end
      end

      context "when non-existing email specified" do
        it "shows failure message" do
          visit new_refinery_user_password_url
          fill_in "refinery_user_email", :with => "none@refinerycms.com"
          click_button "Reset password"
          has_content?("Sorry, 'none@refinerycms.com' isn't associated with any accounts.").should be_true
          has_content?("Are you sure you typed the correct email address?").should be_true
        end
      end
    end
  end
end
