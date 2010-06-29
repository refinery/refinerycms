def login
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
