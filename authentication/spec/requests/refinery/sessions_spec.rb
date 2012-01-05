require "spec_helper"

module Refinery
  describe "sign in" do
    before(:each) do
      FactoryGirl.create(:refinery_user, :username => "ugisozols",
                              :password => "123456",
                              :password_confirmation => "123456")
      visit refinery.new_refinery_user_session_path
    end

    it "shows login form" do
      page.should have_content("Hello! Please sign in.")
      page.should have_content("I forgot my password")
      page.should have_selector("a[href*='/refinery/users/password/new']")
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

  describe 'user sign up' do
    before(:each) do
      User.delete_all
    end

    describe 'when there are no users' do
      it 'allows user creation' do
        # Verify that we can access the sign up page.
        visit refinery.root_path
        page.should have_content("There are no users yet, so we'll set you up first")

        # Fill in user details.
        fill_in 'Username', :with => 'rspec'
        fill_in 'Email', :with => 'rspec@example.com'
        fill_in 'Password', :with => 'spectacular'
        fill_in 'Password confirmation', :with => 'spectacular'

        # Sign up and verify!
        click_button "Sign up"
        page.should have_content("Welcome to Refinery, rspec.")
        page.should have_content("Latest Activity")
        User.count.should == 1
      end
    end
  end
end
