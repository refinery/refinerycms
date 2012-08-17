require "spec_helper"

module Refinery
  describe "search" do
    refinery_login_with :refinery_user

    context "when searched item exists" do
      describe "image extension" do
        let!(:image) { FactoryGirl.create(:image) }

        it "returns found image" do
          visit refinery.admin_images_path
          fill_in "search", :with => "beach"
          click_button "Search"

          within ".actions" do
            page.should have_selector("a[href$='#{image.image_name}']")
          end
        end
      end

      describe "resource extension" do
        before { FactoryGirl.create(:resource) }

        it "returns found resource" do
          visit refinery.admin_resources_path
          fill_in "search", :with => "refinery"
          click_button "Search"
          page.should have_content("Refinery Is Awesome.txt")
        end
      end

      describe "page extension" do
        before { FactoryGirl.create(:page, :title => "Ugis Ozols") }

        it "returns found page" do
          visit refinery.admin_pages_path
          fill_in "search", :with => "ugis"
          click_button "Search"
          page.should have_content("Ugis Ozols")
        end
      end
    end

    context "when searched item don't exist" do
      def shared_stuff
        fill_in "search", :with => "yada yada"
        click_button "Search"
        page.should have_content("Sorry, no results found")
      end

      describe "image extension" do
        it "returns no results" do
          visit refinery.admin_images_path
          shared_stuff
        end
      end

      describe "resource extension" do
        it "returns no results" do
          visit refinery.admin_resources_path
          shared_stuff
        end
      end

      describe "page extension" do
        it "returns no results" do
          visit refinery.admin_pages_path
          shared_stuff
        end
      end
    end
  end
end
