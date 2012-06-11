require "spec_helper"

module Refinery
  module Admin
    describe "Images" do
      refinery_login_with :refinery_user

      context "when no images" do
        it "invites to add one" do
          visit refinery.admin_images_path
          page.should have_content(::I18n.t('no_images_yet', :scope => 'refinery.admin.images.records'))
        end
      end

      it "shows add new image link" do
        visit refinery.admin_images_path
        page.should have_content(::I18n.t('create_new_image', :scope => 'refinery.admin.images.actions'))
        page.should have_selector("a[href*='#{refinery.new_admin_image_path}']")
      end

      context "new/create" do
        it "uploads image", :js => true do
          visit refinery.admin_images_path

          click_link ::I18n.t('create_new_image', :scope => 'refinery.admin.images.actions')

          page.should have_selector 'iframe#dialog_iframe'

          page.within_frame('dialog_iframe') do
            attach_file "image_image", Refinery.roots(:'refinery/images').
                                                join("spec/fixtures/image-with-dashes.jpg")
            click_button ::I18n.t('save', :scope => 'refinery.admin.form_actions')
          end

          page.should have_content(::I18n.t('created', :scope => 'refinery.crudify', :what => "'Image With Dashes'"))
          Refinery::Image.count.should == 1
        end

        it 'is accessible via url' do
          image = Refinery::Image.create(:image => Refinery.roots(:'refinery/images').join("spec/fixtures/image-with-dashes.jpg"))
          get image.url

          response.should be_success
        end
      end

      context "when an image exists" do
        let!(:image) { FactoryGirl.create(:image) }

        context "edit/update" do
          it "updates image" do
            visit refinery.admin_images_path
            page.should have_selector("a[href='#{refinery.edit_admin_image_path(image)}']")

            click_link ::I18n.t('edit', :scope => 'refinery.admin.images')

            page.should have_content("Use current image or replace it with this one...")
            page.should have_selector("a[href*='#{refinery.admin_images_path}']")

            attach_file "image_image", Refinery.roots(:'refinery/images').join("spec/fixtures/fathead.png")
            click_button ::I18n.t('save', :scope => 'refinery.admin.form_actions')

            page.should have_content(::I18n.t('updated', :scope => 'refinery.crudify', :what => "'Fathead'"))
            Refinery::Image.count.should == 1

            lambda { click_link "View this image" }.should_not raise_error
          end
        end

        context "destroy" do
          it "removes image" do
            visit refinery.admin_images_path
            page.should have_selector("a[href='#{refinery.admin_image_path(image)}']")

            click_link ::I18n.t('delete', :scope => 'refinery.admin.images')

            page.should have_content(::I18n.t('destroyed', :scope => 'refinery.crudify', :what => "'Beach'"))
            Refinery::Image.count.should == 0
          end
        end

        context "download" do
          it "succeeds" do
            visit refinery.admin_images_path

            lambda { click_link "View this image" }.should_not raise_error
          end
        end

        describe "switch view" do
          it "shows images in grid" do
            visit refinery.admin_images_path
            page.should have_content(::I18n.t('switch_to', :view_name => 'list', :scope => 'refinery.admin.images.index.view'))
            page.should have_selector("a[href='#{refinery.admin_images_path(:view => 'list')}']")

            click_link "Switch to list view"

            page.should have_content(::I18n.t('switch_to', :view_name => 'grid', :scope => 'refinery.admin.images.index.view'))
            page.should have_selector("a[href='#{refinery.admin_images_path(:view => 'grid')}']")
          end
        end
      end
    end
  end
end
