require "spec_helper"

module Refinery
  describe "sign in" do
    let(:login_path) { refinery.new_refinery_user_session_path }
    let(:login_retry_path) { refinery.refinery_user_session_path }
    let(:admin_path) { refinery.admin_root_path }

    before(:each) do
      FactoryGirl.create(:refinery_user, :username => "ugisozols",
                              :password => "123456",
                              :password_confirmation => "123456")
      visit login_path
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
        current_path.should == admin_path
      end
    end

    context "when supplied data is not valid" do
      it "shows flash error" do
        fill_in "Login", :with => "Hmmm"
        fill_in "Password", :with => "Hmmm"
        click_button "Sign in"
        page.should have_content("Sorry, your login or password was incorrect.")
        current_path.should == login_retry_path
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

  describe 'redirects' do
    let(:protected_path) { refinery.new_admin_user_path }
    let(:login_path) { refinery.new_refinery_user_session_path }

    before(:each) do
      FactoryGirl.create(:refinery_user,
        :username => "ugisozols",
        :password => "123456",
        :password_confirmation => "123456"
      )
    end

    context "when visiting a protected path" do
      before(:each) { visit protected_path }

      it "redirects to the login" do
        current_path.should == login_path
      end

      it "shows login form" do
        page.should have_content("Hello! Please sign in.")
        page.should have_content("I forgot my password")
        page.should have_selector("a[href*='/refinery/users/password/new']")
      end

      it "redirects to the protected path on login" do
        fill_in "Login", :with => "ugisozols"
        fill_in "Password", :with => "123456"
        page.click_button "Sign in"
        current_path.should == protected_path
      end
    end

  end
end
