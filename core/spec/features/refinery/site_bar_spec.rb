require "spec_helper"

module Refinery
  describe "site bar", :type => :feature do
    refinery_login_with :refinery_user

    it "have logout link" do
      visit refinery.admin_dashboard_path

      expect(page).to have_content("Log out")
      expect(page).to have_selector("a[href='/refinery/logout']")
    end

    context "when in backend" do
      before { visit refinery.admin_dashboard_path }

      it "have a 'switch to your website button'" do
        expect(page).to have_content("Switch to your website")
        expect(page).to have_selector("a[href='/']")
      end

      it "switches to frontend" do
        expect(page.current_path).to eq(refinery.admin_dashboard_path)
        click_link "Switch to your website"
        expect(page.current_path).to eq(refinery.root_path)
      end
    end

    context "when in frontend" do
      before do
        # make a page in order to avoid 404
        FactoryGirl.create(:page, :link_url => "/")

        visit refinery.root_path
      end

      it "have a 'switch to your website editor' button" do
        expect(page).to have_content("Switch to your website editor")
        expect(page).to have_selector("a[href='/refinery']")
      end

      it "switches to backend" do
        expect(page.current_path).to eq(refinery.root_path)
        click_link "Switch to your website editor"
        expect(page.current_path).to eq(refinery.admin_root_path)
      end
    end
  end
end
