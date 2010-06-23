def create_user
  params = {
    "login" => "cucumber",
    "email" => "cucumber@isavegetable.com",
    "password" => "greenandjuicy",
    "password_confirmation" => "greenandjuicy"
  }
  if @user.nil?
    @user = User.create(params)
    Refinery::Plugins.registered.each do |plugin|
      @user.plugins.create(:name => plugin.name)
    end
  end
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

