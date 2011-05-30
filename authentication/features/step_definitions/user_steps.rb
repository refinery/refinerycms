def login
  visit new_refinery_user_session_path
  fill_in("refinery_user_login", :with => @refinery_user.email)
  fill_in("refinery_user_password", :with => 'greenandjuicy')
  click_button("submit_button")
end

Given /^I am a logged in refinery user$/i do
  @refinery_user ||= Factory(:refinery_user)
  login
end

Given /^I am a logged in refinery translator$/i do
  @refinery_user ||= Factory(:refinery_translator)
  login
end

Given /^I am a logged in customer$/i do
  @refinery_user ||= Factory(:user)
  login
end

Given /^A Refinery user exists$/i do
  @refinery_user ||= Factory(:refinery_user)
end

Given /^I have a user named "(.*)"$/ do |name|
  Factory(:user, :username => name)
end

Given /^I have a refinery user named "(.*)"$/i do |name|
  Factory(:refinery_user, :username => name)
end

Given /^I have no users$/ do
  ::Refinery::User.delete_all
end

Then /^I should have ([0-9]+) users?$/ do |count|
  ::Refinery::User.count.should == count.to_i

end
