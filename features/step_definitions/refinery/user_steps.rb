def create_default_user()
  params = {
    "login" => "cucumber",
    "email" => "cucumber@isavegetable.com",
    "password" => "greenandjuicy",
    "password_confirmation" => "greenandjuicy"
  }
  if @user.nil?
    @user = User.create(params)
    @user.roles << Role.find_or_create_by_title('Refinery')
    Refinery::Plugins.registered.each do |plugin|
      @user.plugins.create(:title => plugin.title)
    end
  end
end

def create_user(options = {})
  params = {
    "password" => "greenandjuicy",
    "password_confirmation" => "greenandjuicy"
  }.merge(options)
  User.create(params)
end

def login
  create_default_user
  visit '/refinery'
  fill_in("session_login", :with => @user.email)
  fill_in("session_password", :with => @user.password)
  click_button("submit_button")
end

Given /^I am a logged in user$/ do
  login
end

Given /^I have a user named (.*)$/ do |name|
  create_user("login" => name, "email" => "something@something.com")
end
