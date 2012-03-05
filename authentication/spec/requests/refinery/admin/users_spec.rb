require "spec_helper"

describe "User admin page" do
  login_refinery_user

  describe "new/create" do
    it "can create a user" do
      visit refinery.admin_users_path
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
    it "can update a user" do
      visit refinery.admin_users_path
      click_link "Edit this user"

      fill_in "Username", :with => "cmsrefinery"
      fill_in "Email", :with => "cms@refinerycms.com"
      click_button "Save"

      page.should have_content("cmsrefinery was successfully updated.")
      page.should have_content("cmsrefinery (cms@refinerycms.com)")
    end
  end

  describe "destroy" do
    let!(:user) { FactoryGirl.create(:user, :username => "ugisozols") }

    it "can only destroy regular users" do
      visit refinery.admin_users_path
      page.should have_selector("a[href='/refinery/users/#{user.username}']")
      page.should have_no_selector("a[href='/refinery/users/#{logged_in_user.username}']")

      click_link "Remove this user"
      page.should have_content("'#{user.username}' was successfully removed.")
      page.should have_content("#{logged_in_user.username} (#{logged_in_user.email})")
    end
  end
end
