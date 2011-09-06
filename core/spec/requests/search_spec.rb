require "spec_helper"

module Refinery
  describe "search" do
    login_refinery_user

    context "when searched item exists" do
      describe "image engine" do
        before(:each) { FactoryGirl.create(:image) }

        it "returns found image" do
          visit refinery_admin_images_path
          fill_in "search", :with => "beach"
          click_button "Search"
          page.should have_selector("img[src*='beach.jpeg']")
        end
      end

      describe "resource engine" do
        before(:each) { FactoryGirl.create(:resource) }

        it "returns found resource" do
          visit refinery_admin_resources_path
          fill_in "search", :with => "refinery"
          click_button "Search"
          page.should have_content("Refinery Is Awesome.txt")
        end
      end

      describe "page engine" do
        before(:each) { FactoryGirl.create(:page, :title => "Ugis Ozols") }

        it "returns found page" do
          visit refinery_admin_pages_path
          fill_in "search", :with => "ugis"
          click_button "Search"
          page.should have_content("Ugis Ozols")
        end
      end

      describe "setting engine" do
        before(:each) { Refinery::Setting.set(:testy, true) }

        it "returns found setting" do
          visit refinery_admin_settings_path
          fill_in "search", :with => "testy"
          click_button "Search"
          page.should have_content("Testy - true")
        end
      end
    end

    context "when searched item don't exist" do
      def shared_stuff
        fill_in "search", :with => "yada yada"
        click_button "Search"
        page.should have_content("Sorry, no results found")
      end

      describe "image engine" do
        it "returns no results" do
          visit refinery_admin_images_path
          shared_stuff
        end
      end

      describe "resource engine" do
        it "returns no results" do
          visit refinery_admin_resources_path
          shared_stuff
        end
      end

      describe "page engine" do
        it "returns no results" do
          visit refinery_admin_pages_path
          shared_stuff
        end
      end

      describe "setting engine" do
        it "returns no results" do
          visit refinery_admin_settings_path
          shared_stuff
        end
      end
    end
  end
end
