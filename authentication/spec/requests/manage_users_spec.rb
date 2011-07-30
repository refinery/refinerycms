require "spec_helper"

describe "manage users" do
  # TODO: share this with other request specs
  before(:each) do
    Factory(:refinery_user, :username => "refinerycms",
                            :password => "123456",
                            :password_confirmation => "123456")
    visit new_refinery_user_session_url
    fill_in "Login", :with => "refinerycms"
    fill_in "Password", :with => "123456"
    click_button "Sign in"
  end

  describe "new/create" do
    it "allows to create user" do
      visit refinery_admin_users_url
      click_link "Add new user"

      fill_in "Username", :with => "test"
      fill_in "Email", :with => "test@refinerycms.com"
      fill_in "Password", :with => "123456"
      fill_in "Password confirmation", :with => "123456"
      click_button "Save"

      page.should have_content("test was successfully added.")
      page.should have_content("test (test@refinerycms.com)")
    end
  end

  describe "edit/update" do
    it "allows to update user" do
      visit refinery_admin_users_url
      click_link "Edit this user"

      fill_in "Username", :with => "cmsrefinery"
      fill_in "Email", :with => "cms@refinerycms.com"
      click_button "Save"

      page.should have_content("cmsrefinery was successfully updated.")
      page.should have_content("cmsrefinery (cms@refinerycms.com)")
    end
  end
end
