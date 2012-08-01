require "spec_helper"

module Refinery
  describe "dialog" do
    login_refinery_user

    context "links" do
      it "have iframe src" do
        visit refinery.admin_dialog_path('Link')
        page.should have_selector("iframe[src='/refinery/pages_dialogs/link_to']")
      end
    end

    context "images" do
      it "have iframe src" do
        visit refinery.admin_dialog_path('Image')
        page.should have_selector("iframe[src='/refinery/images/insert?modal=true']")
      end
    end

    context "a" do
      it "404s" do
        Admin::DialogsController.any_instance.should_receive(:error_404).once

        visit refinery.admin_dialog_path('a')
      end
    end
  end
end
