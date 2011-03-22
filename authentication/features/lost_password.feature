@refinerycms @authentication @users @users-password
Feature: Lost Password
    In order to restore my password
    As a lost soul
    I want to reset my password

    Background:
      Given A Refinery user exists

    @users-password-forgot
    Scenario: Forgot Password page (no email entered)
      And I am on the forgot password page
      When I press "Reset password"
      Then I should see "You did not enter an email address."

    @users-password-forgot
    Scenario: Forgot Password page (non existing email entered)
      Given I am on the forgot password page
      And I have a user with email "green@cukes.com"
      When I fill in "user_email" with "none@cukes.com"
      And I press "Reset password"
      Then I should see "Sorry, 'none@cukes.com' isn't associated with any accounts."
      And I should see "Are you sure you typed the correct email address?"

    @users-password-forgot
    Scenario: Forgot Password page (existing email entered)
      Given I am on the forgot password page
      And I have a user with email "green@cukes.com"
      When I fill in "user_email" with "green@cukes.com"
      And I press "Reset password"
      Then I should see "An email has been sent to you with a link to reset your password."

    @users-password-reset
    Scenario: Reset password page (invalid reset_code)
      Given I am not requesting password reset
      When I go to the reset password page
      Then I should be on the forgot password page
      And I should see "We're sorry, but this reset code has expired or is invalid."
      And I should see "If you are having issues try copying and pasting the URL from your email into your browser or restarting the reset password process."

    @users-password-reset
    Scenario: Reset password page (valid reset_code)
      Given I am requesting password reset
      When I go to the reset password page
      And I fill in "Password" with "cukes"
      And I fill in "Password confirmation" with "cukes"
      And I press "Reset password"
      Then I should be on the admin root
      And I should see "Password reset successfully for"
