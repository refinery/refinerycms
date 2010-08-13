Given /^I have a user with email "(.*)"$/ do |email|
  Factory(:user, :email => email)
end

Given /^I am (not )?requesting password reset$/ do |action|
  @user = Factory(:user, :updated_at => 11.minutes.ago)
  @user.reset_perishable_token! if action.nil?
end
