require "spec_helper"

module Refinery
  module Users
    describe "password recovery" do
      let!(:user) { create(:refinery_user, :email => "refinery@refinerycms.com") }

      it "asks user to specify email address" do
        visit refinery.login_path
        click_link "I forgot my password"
        page.should have_content("Please enter the email address for your account.")
      end

      context "when existing email specified" do
        it "shows success message" do
          visit refinery.new_refinery_user_password_path
          fill_in "refinery_user_email", :with => user.email
          click_button "Reset password"
          page.should have_content("An email has been sent to you with a link to reset your password.")
        end
      end

      context "when non-existing email specified" do
        it "shows failure message" do
          visit refinery.new_refinery_user_password_path
          fill_in "refinery_user_email", :with => "none@refinerycms.com"
          click_button "Reset password"
          page.should have_content("Sorry, 'none@refinerycms.com' isn't associated with any accounts.")
          page.should have_content("Are you sure you typed the correct email address?")
        end
      end

      context "when good reset code" do
        before do
          user.reset_password_sent_at = 5.minutes.ago
          user.reset_password_token = "refinerycms"
          user.save
        end

        it "allows to change password" do
          visit refinery.edit_refinery_user_password_path(:reset_password_token => user.reset_password_token)
          page.should have_content("Pick a new password for #{user.email}")

          fill_in "refinery_user_password", :with => "123456"
          fill_in "refinery_user_password_confirmation", :with => "123456"
          click_button "Reset password"

          page.should have_content("Password reset successfully for '#{user.email}'")
        end
      end

      context "when invalid reset code" do
        before do
          user.reset_password_sent_at = 5.minutes.ago
          user.reset_password_token = "refinerycms"
          user.save
        end

        it "shows error message" do
          visit refinery.edit_refinery_user_password_path(:reset_password_token => "hmmm")
          page.should have_content("We're sorry, but this reset code has expired or is invalid.")
        end
      end

      context "when expired reset code" do
        before do
          user.reset_password_sent_at = 1.day.ago
          user.reset_password_token = "refinerycms"
          user.save
        end

        it "shows error message" do
          visit refinery.edit_refinery_user_password_path(:reset_password_token => "refinerycms")

          fill_in "refinery_user_password", :with => "123456"
          fill_in "refinery_user_password_confirmation", :with => "123456"
          click_button "Reset password"

          page.should have_content("Reset password token has expired, please request a new one")
        end
      end
    end
  end
end
