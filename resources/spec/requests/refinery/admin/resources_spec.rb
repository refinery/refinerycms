require "spec_helper"

module Refinery
  module Admin
    describe "Resources" do
      login_refinery_user

      before(:all) do
        @max_client_body_size = Refinery::Resources.max_client_body_size
      end

      after(:all) do
        Refinery::Resources.max_client_body_size = @max_client_body_size
      end

      context "when no files" do
        it "invites to upload file" do
          visit refinery_admin_resources_path
          page.should have_content("There are no files yet. Click \"Upload new file\" to add your first file.")
        end
      end

      it "shows upload file link" do
        visit refinery_admin_resources_path
        page.should have_content("Upload new file")
        page.should have_selector("a[href*='/refinery/resources/new']")
      end

      context "new/create" do
        it "uploads file", :js => true do
          visit refinery_admin_resources_path
          click_link "Upload new file"

          within_frame "dialog_iframe" do
            attach_file "resource_file", Refinery.roots("testing").join("assets/refinery_is_awesome.txt")
            click_button "Save"
          end

          page.should have_content("Refinery Is Awesome.txt")
          Refinery::Resource.count.should == 1
        end
      end

      context "edit/update" do
        let!(:resource) { FactoryGirl.create(:resource) }

        it "updates file" do
          visit refinery_admin_resources_path
          page.should have_content("Refinery Is Awesome.txt")
          page.should have_selector("a[href='/refinery/resources/#{resource.id}/edit']")

          click_link "Edit this file"

          page.should have_content("Download current file or replace it with this one...")
          page.should have_selector("a[href='/refinery/resources']")

          attach_file "resource_file", Refinery.roots("testing").join("assets/refinery_is_awesome2.txt")
          click_button "Save"

          page.should have_content("Refinery Is Awesome2")
          Refinery::Resource.count.should == 1
        end
      end

      context "destroy" do
        let!(:resource) { FactoryGirl.create(:resource) }

        it "removes file" do
          visit refinery_admin_resources_path
          page.should have_selector("a[href='/refinery/resources/#{resource.id}']")

          click_link "Remove this file forever"

          page.should have_content("'Refinery Is Awesome' was successfully removed.")
          Refinery::Resource.count.should == 0
        end
      end

      context "download" do
        let!(:resource) { FactoryGirl.create(:resource) }

        it "succeedes" do
          visit refinery_admin_resources_path

          click_link "Download this file"

          page.should have_content("http://www.refineryhq.com/")
        end
      end
    end
  end
end
