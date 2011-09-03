require "spec_helper"

describe "sign in" do
  before(:each) do
    FactoryGirl.create(:refinery_user, :username => "ugisozols",
                            :password => "123456",
                            :password_confirmation => "123456")
    visit new_refinery_user_session_path
  end

  it "shows login form" do
    page.should have_content("Hello! Please sign in.")
    page.should have_content("I forgot my password")
    page.should have_selector("a[href='/refinery/users/password/new']")
  end

  context "when supplied data is valid" do
    it "logs in user" do
      fill_in "Login", :with => "ugisozols"
      fill_in "Password", :with => "123456"
      click_button "Sign in"
      page.should have_content("Signed in successfully.")
    end
  end

  context "when supplied data is not valid" do
    it "shows flash error" do
      fill_in "Login", :with => "Hmmm"
      fill_in "Password", :with => "Hmmm"
      click_button "Sign in"
      page.should have_content("Sorry, your login or password was incorrect.")
    end
  end
end
