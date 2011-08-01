require "spec_helper"

describe "manage users" do
  it_should_behave_like 'refinery admin'

  before(:each) do
    visit refinery_admin_users_url
  end

  describe "new/create" do
    it "allows to create user" do
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
      click_link "Edit this user"

      fill_in "Username", :with => "cmsrefinery"
      fill_in "Email", :with => "cms@refinerycms.com"
      click_button "Save"

      page.should have_content("cmsrefinery was successfully updated.")
      page.should have_content("cmsrefinery (cms@refinerycms.com)")
    end
  end
end
