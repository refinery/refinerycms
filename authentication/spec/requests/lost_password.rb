require "spec_helper"

require File.expand_path("../../../features/support/factories", __FILE__)

module Refinery
  module Users
    describe "password recovery form" do
      let(:user) { Factory(:user, :email => "refinery@refinerycms.com") }

      it "asks user to specify email address" do
        visit new_refinery_user_session_url
        click_link "I forgot my password"
        find("h1", :text => "Please enter the email address for your account.").should be_true
      end

      context "when existing email specified" do
        it "shows success flash message" do
          visit new_refinery_user_password_url
          fill_in "refinery_user_email", :with => user.email
          click_button "Reset password"
          find(".flash_notice", :text => "An email has been sent to you with a link to reset your password.")
        end
      end

      context "when non-existing email specified" do
        it "shows failure flash message" do
          visit new_refinery_user_password_url
          fill_in "refinery_user_email", :with => "none@refinerycms.com"
          click_button "Reset password"
          find(".flash_error", :text => "Sorry, 'none@refinerycms.com' isn't associated with any accounts.")
          find(".flash_error", :text => "Are you sure you typed the correct email address?")
        end
      end
    end
  end
end
