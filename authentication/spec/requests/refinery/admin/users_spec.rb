require "spec_helper"

describe "User admin page" do
  login_refinery_superuser

  describe "new/create" do
    def visit_and_fill_form
      visit refinery.admin_users_path
      click_link "Add new user"

      fill_in "Username", :with => "test"
      fill_in "Email", :with => "test@refinerycms.com"
      fill_in "Password", :with => "123456"
      fill_in "Password confirmation", :with => "123456"
    end

    it "can create a user" do
      visit_and_fill_form

      click_button "Save"

      page.should have_content("test was successfully added.")
      page.should have_content("test (test@refinerycms.com)")
    end

    context "when assigning roles config is enabled" do
      before do
        Refinery::Authentication.stub(:superuser_can_assign_roles).and_return(true)
      end

      it "allows superuser to assign roles" do
        visit_and_fill_form

        within "#roles" do
          check "roles_#{Refinery::Role.first.title.downcase}"
        end
        click_button "Save"

        page.should have_content("test was successfully added.")
        page.should have_content("test (test@refinerycms.com)")
      end
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

    let(:dotty_user) { FactoryGirl.create(:refinery_user, :username => 'user.name.with.lots.of.dots') }
    it "accepts a username with a '.' in it" do
      dotty_user # create the user
      visit refinery.admin_users_path

      page.should have_css("#sortable_#{dotty_user.id}")

      within "#sortable_#{dotty_user.id}" do
        click_link "Edit this user"
      end

      page.should have_css("form#edit_user_#{dotty_user.id}")
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
