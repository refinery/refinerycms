Given /^I have no files$/ do
  ::Refinery::Resource.destroy_all
end

When /^I upload the file at "([^\"]*)"$/ do |file_path|
  Factory(:resource)
end

Given /^I have no images$/ do
  ::Refinery::Image.destroy_all
end

When /^I upload the image at "([^\"]*)"$/ do |file_path|
  Factory(:image)
end

def login(options = {})
  options = {:user => @refinery_user}.merge(options)
  visit new_refinery_user_session_path
  fill_in("refinery_user_login", :with => options[:user].email)
  fill_in("refinery_user_password", :with => 'greenandjuicy')
  click_button("submit_button")
end

Given /^I am a logged in refinery user$/i do
  @refinery_user ||= Factory(:refinery_user)
  login(:user => @refinery_user)
end

Given /^I am a logged in refinery translator$/i do
  @refinery_translator ||= Factory(:refinery_translator)
  login(:user => @refinery_translator)
end

Given /^I am a logged in customer$/i do
  @user ||= Factory(:user)
  login(:user => @user)
end

Given /^A Refinery user exists$/i do
  @refinery_user ||= Factory(:refinery_user)
end

Given /^I have no (?:|refinery )settings$/ do
  ::Refinery::Setting.delete_all
end

Given /^I (only )?have a (?:|refinery )setting titled "([^\"]*)"$/ do |only, title|
  ::Refinery::Setting.delete_all if only

  ::Refinery::Setting.set(title.to_s.gsub(' ', '').underscore.to_sym, nil)
end
