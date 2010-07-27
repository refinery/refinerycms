def login
  @user ||= Factory(:refinery_user)
  visit admin_root_url
  fill_in("session_login", :with => @user.email)
  fill_in("session_password", :with => @user.password)
  click_button("submit_button")
end

Given /^I am a logged in refinery user$/ do
  @user ||= Factory(:refinery_user)
  login
end

Given /^I am a logged in customer$/ do
  @user ||= Factory(:user)
  login
end

Given /^A Refinery user exists$/ do
  @refinery_user ||= Factory(:refinery_user)
end

Given /^I have a user named "(.*)"$/ do |name|
  Factory(:user, :login => name)
end

Given /^I have no users$/ do
  User.delete_all
end

Then /^I should have ([0-9]+) users?$/ do |count|
  User.count.should == count.to_i
end
