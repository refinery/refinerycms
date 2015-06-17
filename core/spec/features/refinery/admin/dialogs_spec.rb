require "spec_helper"

module Refinery
  describe "dialog", :type => :feature do
    refinery_login

    context "links" do
      it "have iframe src" do
        skip("GLASS: TODO: dialogs have been replaced with bootstrap modals, remove them")
        visit refinery.admin_dialog_path('Link')
        expect(page).to have_selector("iframe[src='/refinery/pages_dialogs/link_to']")
      end
    end

    context "images" do
      it "have iframe src" do
        skip("GLASS: TODO: dialogs have been replaced with bootstrap modals, remove them")
        visit refinery.admin_dialog_path('Image')
        expect(page).to have_selector("iframe[src='/refinery/images/insert?modal=true']")
      end
    end

    context "a" do
      it "404s" do
        skip("GLASS: TODO: dialogs have been replaced with bootstrap modals, remove them")
        expect_any_instance_of(Admin::DialogsController).to receive(:error_404).once

        visit refinery.admin_dialog_path('a')
      end
    end
  end
end
