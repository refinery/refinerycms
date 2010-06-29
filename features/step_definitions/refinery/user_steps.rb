def login
  @user ||= Factory(:refinery_user)
  visit '/refinery'
  fill_in("session_login", :with => @user.email)
  fill_in("session_password", :with => @user.password)
  click_button("submit_button")
end

Given /^I am a logged in user$/ do
  @user ||= Factory(:refinery_user)
  login
end

Given /^I am a logged in customer$/ do
  @user ||= Factory(:user)
  login
end

Given /^I have a user named (.*)$/ do |name|
  Factory(:user, :login => name)
end

Given /^I have no users$/ do
  User.delete_all
end

Then /^I should have ([0-9]+) users?$/ do |count|
  User.count.should == count.to_i
end
