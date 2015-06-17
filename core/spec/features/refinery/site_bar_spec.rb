require "spec_helper"

module Refinery
  describe "site bar", :type => :feature do
    refinery_login

    describe "logout link" do
      let(:logout_path) { '/refinery/logout' }

      context "when set" do
        before do
          allow(Refinery::Core).to receive(:refinery_logout_path).and_return(logout_path)
          visit Refinery::Core.backend_path
        end

        it "is present" do
          skip "GLASS: there are plans to add this back in"
          expect(page).to have_selector("a[href='#{logout_path}']")
          expect(page).to have_content("Log out")
        end
      end

      context "when not set" do
        it "is not present" do
          visit Refinery::Core.backend_path
          expect(page).not_to have_content("Log out")
          expect(page).not_to have_selector("a[href='#{logout_path}']")
        end
      end
    end

    context "when in backend" do
      before do
        visit Refinery::Core.backend_path
      end

      it "has a 'switch to your website button'" do
        skip "GLASS: test is failing sometimes, 'Company Name' is not found"
        expect(page).to have_content("Company Name")
        expect(page).to have_selector("a[href='/']")
      end

      it "switches to frontend" do
        skip "GLASS: test is failing sometimes, 'Company Name' is not found"
        expect(page.current_path).to match(/\A#{Refinery::Core.backend_path}/)
        click_link "Company Name"
        expect(page.current_path).to eq(refinery.root_path)
      end
    end

    context "when in frontend" do
      # make a page in order to avoid 404
      let!(:root_page) { FactoryGirl.create(:page, :link_url => "/") }
      before { visit refinery.root_path }

      it "has a 'switch to your website editor' button" do
        skip "GLASS: there are plans to add this back in"
        expect(page).to have_content("Switch to your website editor")
        expect(page).to have_selector("a[href='/refinery']")
      end

      it "switches to backend" do
        skip "GLASS: there are plans to add this back in"
        expect(page.current_path).to eq(refinery.root_path)
        click_link "Switch to your website editor"
        expect(page.current_path).to match(/\A#{Refinery::Core.backend_path}/)
      end

      it "has an 'edit this page' button" do
        skip "GLASS: there are plans to add this back in"
        expect(page).to have_link("Edit this page", :href => refinery.edit_admin_page_path(root_page))
      end

    end
  end
end
