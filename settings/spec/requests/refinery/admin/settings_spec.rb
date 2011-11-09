require "spec_helper"

module Refinery
  module Admin
    describe "Settings" do
      login_refinery_user

      context "when no settings" do
        before(:each) { Refinery::Setting.destroy_all }

        it "invites to create one" do
          visit refinery_admin_settings_path
          page.should have_content("There are no settings yet. Click 'Add new setting' to add your first setting.")
        end
      end

      it "shows add new setting link" do
        visit refinery_admin_settings_path
        page.should have_content("Add new setting")
        page.should have_selector("a[href*='/refinery/settings/new']")
      end

      context "new/create" do
        it "adds setting", :js => true do
          visit refinery_admin_settings_path
          click_link "Add new setting"

          fill_in "Name", :with => "test setting"
          fill_in "Value", :with => "true"
          click_button "Save"

          page.should have_content("'Test Setting' was successfully added.")
          page.should have_content("Test Setting - true")
        end
      end

      context "pagination" do
        before(:each) do
          (Refinery::Setting.per_page + 1).times do
            Refinery::Setting.create! :name => "Refinery CMS"
          end
        end

        specify "page links" do
          visit refinery_admin_settings_path

          page.should have_selector("a[href*='settings?page=2']")
        end
      end
    end
  end
end
