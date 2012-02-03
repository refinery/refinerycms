require "spec_helper"

module Refinery
  describe "AdminImages" do
    login_refinery_user

    context "when no images" do
      it "invites to add one" do
        visit refinery.admin_images_path
        page.should have_content(%q{There are no images yet. Click "Add new image" to add your first image.})
      end
    end

    it "shows add new image link" do
      visit refinery.admin_images_path
      page.should have_content("Add new image")
      page.should have_selector("a[href*='/refinery/images/new']")
    end

    context "new/create" do
      it "uploads image", :js => true do
        visit refinery.admin_images_path

        click_link "Add new image"

        page.should have_selector('iframe#dialog_iframe')

        page.within_frame "dialog_iframe" do
          attach_file "image_image", Refinery.roots(:'refinery/images').join("spec/fixtures/image-with-dashes.jpg")
          click_button "Save"
        end

        page.should have_content("'Image With Dashes' was successfully added.")
        Refinery::Image.count.should == 1

        get Refinery::Image.last.url

        response.should be_success
      end
    end

    context "edit/update" do
      let!(:image) { FactoryGirl.create(:image) }

      it "updates image" do
        visit refinery.admin_images_path
        page.should have_selector("a[href='/refinery/images/#{image.id}/edit']")

        click_link "Edit this image"

        page.should have_content("Use current image or replace it with this one...")
        page.should have_selector("a[href*='/refinery/images']")

        attach_file "image_image", Refinery.roots(:'refinery/images').join("spec/fixtures/fathead.png")
        click_button "Save"

        page.should have_content("'Fathead' was successfully updated.")
        Refinery::Image.count.should == 1

        lambda { click_link "View this image" }.should_not raise_error
      end
    end

    context "destroy" do
      let!(:image) { FactoryGirl.create(:image) }

      it "removes image" do
        visit refinery.admin_images_path
        page.should have_selector("a[href='/refinery/images/#{image.id}']")

        click_link "Remove this image forever"

        page.should have_content("'Beach' was successfully removed.")
        Refinery::Image.count.should == 0
      end
    end

    context "download" do
      let!(:image) { FactoryGirl.create(:image) }

      it "succeeds" do
        visit refinery.admin_images_path

        lambda { click_link "View this image" }.should_not raise_error
      end
    end

    describe "switch view" do
      let!(:image) { FactoryGirl.create(:image) }

      it "shows images in grid" do
        visit refinery.admin_images_path
        page.should have_content("Switch to list view")
        page.should have_selector("a[href='/refinery/images?view=list']")

        click_link "Switch to list view"

        page.should have_content("Switch to grid view")
        page.should have_selector("a[href='/refinery/images?view=grid']")
      end
    end
  end
end
