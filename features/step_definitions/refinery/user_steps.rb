def create_user
  params = {
    "login" => "cucumber",
    "email" => "cucumber@isavegetable.com",
    "password" => "greenandjuicy",
    "password_confirmation" => "greenandjuicy"
  }
  @user ||= User.create(params)
end

def login
  create_user
  visit '/refinery'
  fill_in("session_login", :with => @user.email)
  fill_in("session_password", :with => @user.password)
  click_button("submit_button")
end

Given /^I am a logged in user$/ do
  login
end

