require "spec_helper"

module Refinery
  describe "site bar", :type => :feature do
    refinery_login_with :refinery_user

    it "has a logout link" do
      visit Refinery::Core.backend_path

      expect(page).to have_content("Log out")
      expect(page).to have_selector("a[href='/refinery/logout']")
    end

    context "when in backend" do
      before { visit Refinery::Core.backend_path }

      it "has a 'switch to your website button'" do
        expect(page).to have_content("Switch to your website")
        expect(page).to have_selector("a[href='/']")
      end

      it "switches to frontend" do
        expect(page.current_path).to match(/\A#{Refinery::Core.backend_path}/)
        click_link "Switch to your website"
        expect(page.current_path).to eq(refinery.root_path)
      end
    end

    context "when in frontend" do
      # make a page in order to avoid 404
      let!(:root_page) { FactoryGirl.create(:page, :link_url => "/") }
      before { visit refinery.root_path }

      it "has a 'switch to your website editor' button" do
        expect(page).to have_content("Switch to your website editor")
        expect(page).to have_selector("a[href='/refinery']")
      end

      it "switches to backend" do
        expect(page.current_path).to eq(refinery.root_path)
        click_link "Switch to your website editor"
        expect(page.current_path).to match(/\A#{Refinery::Core.backend_path}/)
      end

      it "has an 'edit this page' button" do
        expect(page).to have_link("Edit this page", :href => refinery.edit_admin_page_path(root_page))
      end

    end
  end
end
