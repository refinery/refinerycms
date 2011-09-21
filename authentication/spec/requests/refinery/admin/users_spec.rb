require "spec_helper"

describe "manage users" do
  login_refinery_user

  describe "new/create" do
    it "allows to create user" do
      visit refinery_admin_users_path
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
      visit refinery_admin_users_path
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

    it "allows to destroy only regular user" do
      visit refinery_admin_users_path
      page.should have_selector("a[href='/refinery/users/#{user.username}']")
      page.should have_no_selector("a[href='/refinery/users/refinerycms']")

      click_link "Remove this user"
      page.should have_content("'#{user.username}' was successfully removed.")
      page.should have_content("refinerycms (refinerycms@refinerycms.com)")
    end
  end
end
