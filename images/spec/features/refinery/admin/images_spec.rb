require "spec_helper"

module Refinery
  describe "AdminImages", type: :feature do
    refinery_login_with :refinery_user

    context "when no images" do
      it "invites to add one" do
        visit refinery.admin_images_path
        expect(page).to have_content(::I18n.t('no_images_yet', scope: 'refinery.admin.images.records'))
      end
    end

    it "shows add new image link" do
      visit refinery.admin_images_path
      expect(page).to have_content(::I18n.t('create_new_image', scope: 'refinery.admin.images.actions'))
      expect(page).to have_selector("a[href*='#{refinery.new_admin_image_path}']")
    end

    context "new/create" do
      it "uploads image with default title and alt text", js: true do
        visit refinery.admin_images_path

        click_link ::I18n.t('create_new_image', scope: 'refinery.admin.images.actions')

        expect(page).to have_selector 'iframe#dialog_iframe'

        page.within_frame('dialog_iframe') do
          attach_file "image_image", Refinery.roots('refinery/images').
                                              join("spec/fixtures/image-with-dashes.jpg")
          click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
        end

        expect(page).to have_content(::I18n.t('created', scope: 'refinery.crudify', what: "'Image With Dashes'"))
        expect(Refinery::Image.where(image_title: 'Image With Dashes', image_alt: '')).to exist
        expect(Refinery::Image.count).to eq(1)
      end

      it "uploads image with specific title and alt text", js: true do
        visit refinery.admin_images_path

        click_link ::I18n.t('create_new_image', scope: 'refinery.admin.images.actions')

        expect(page).to have_selector 'iframe#dialog_iframe'

        page.within_frame('dialog_iframe') do
          attach_file "image_image", Refinery.roots('refinery/images').
                                              join("spec/fixtures/image-with-dashes.jpg")
          fill_in  'image_image_title', with: 'Image Title'
          fill_in  'image_image_alt', with: 'Alt Text'

          click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
        end

        expect(page).to have_content(::I18n.t('created', scope: 'refinery.crudify', what: "'Image Title'"))
        expect(Refinery::Image.where(image_title: 'Image Title', image_alt: 'Alt Text')).to exist
        expect(Refinery::Image.count).to eq(1)

      end

      it "cannot upload a pdf", js: true do
        visit refinery.admin_images_path

        click_link ::I18n.t('create_new_image', scope: 'refinery.admin.images.actions')

        expect(page).to have_selector 'iframe#dialog_iframe'

        page.within_frame('dialog_iframe') do
          attach_file "image_image", Refinery.roots('refinery/images').
                                              join("spec/fixtures/cape-town-tide-table.pdf")
          click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
        end

        page.within_frame('dialog_iframe') do
          expect(page).to have_content(::I18n.t('incorrect_format', scope: 'activerecord.errors.models.refinery/image'))
        end
        expect(Refinery::Image.count).to eq(0)
      end
    end

    context "new/create - insert mode" do
      it "uploads image", :js => true do
        visit refinery.insert_admin_images_path(:modal => true)

        attach_file "image_image", Refinery.roots('refinery/images').join("spec/fixtures/image-with-dashes.jpg")
        click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')

        expect(page).to have_selector('#existing_image_area', visible: true)
        expect(Refinery::Image.count).to eq(1)
      end

      it "gets error message when uploading non-image", :js => true do
        visit refinery.insert_admin_images_path(:modal => true)

        attach_file "image_image", Refinery.roots('refinery/images').join("spec/fixtures/cape-town-tide-table.pdf")
        click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')

        expect(page).to have_selector('#upload_image_area', visible: true)
        expect(page).to have_content(::I18n.t('incorrect_format', scope: 'activerecord.errors.models.refinery/image'))
        expect(Refinery::Image.count).to eq(0)
      end

      it "gets error message when uploading non-image (when an image already exists)", js: true do
        FactoryGirl.create(:image)
        visit refinery.insert_admin_images_path(:modal => true)

        choose 'Upload'
        attach_file "image_image", Refinery.roots('refinery/images').join("spec/fixtures/cape-town-tide-table.pdf")
        click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')

        expect(page).to have_selector('#upload_image_area', visible: true)
        expect(page).to have_content(::I18n.t('incorrect_format', scope: 'activerecord.errors.models.refinery/image'))
        expect(Refinery::Image.count).to eq(1)
      end
    end

    context "when an image exists" do
      let!(:image) { FactoryGirl.create(:image) }

      context "edit/update" do
        it "updates image" do
          visit refinery.admin_images_path
          expect(page).to have_selector("a[href='#{refinery.edit_admin_image_path(image)}']")

          click_link ::I18n.t('edit', scope: 'refinery.admin.images')

          expect(page).to have_content("Use current image or replace it with this one...")
          expect(page).to have_selector("a[href*='#{refinery.admin_images_path}']")

          attach_file "image_image", Refinery.roots('refinery/images').join("spec/fixtures/beach.jpeg")
          click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')

          expect(page).to have_content(::I18n.t('updated', scope: 'refinery.crudify', what: "'Beach'"))
          expect(Refinery::Image.count).to eq(1)

          expect { click_link "View this image" }.not_to raise_error
        end

        it "doesn't allow updating if image has different file name" do
          visit refinery.edit_admin_image_path(image)

          attach_file "image_image", Refinery.roots('refinery/images').join("spec/fixtures/fathead.png")
          click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')

          expect(page).to have_content(::I18n.t("different_file_name",
                                            scope: "activerecord.errors.models.refinery/image"))
        end
      end

      context "page" do
       # Regression test for #2552 (https://github.com/refinery/refinerycms/issues/2552)
        let :page_for_image do
          page = Refinery::Page.create title: "Add Image to me"
          # we need page parts so that there's a visual editor
          Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
            page.parts.create(title: default_page_part, body: nil, position: index)
          end
          page
        end
        it "can add an image to a page and update the image", js: true do
          visit refinery.edit_admin_page_path(page_for_image)

          # add image to the page
          expect(page.body).to  match(/Add Image/)
          click_link 'Add Image'
          expect(page).to have_selector 'iframe#dialog_frame'
          page.within_frame('dialog_frame') do
            find(:css, "#existing_image_area img#image_#{image.id}").click
            find(:css, '#existing_image_size_area #image_dialog_size_0').click
            click_button ::I18n.t('button_text', scope: 'refinery.admin.images.existing_image')
          end
          click_button "Save"

          # check that image loads after it has been updated
          visit refinery.url_for(page_for_image.url)
          visit find(:css, 'img[src^="/system/images"]')[:src]
          expect(page).to have_css('img[src*="/system/images"]')
          expect { page }.to_not have_content('Not found')

          # update the image
          visit refinery.edit_admin_image_path(image)
          attach_file "image_image", Refinery.roots('refinery/images').join("spec/fixtures/beach.jpeg")
          click_button "Save"

          # check that image loads after it has been updated
          visit refinery.url_for(page_for_image.url)
          visit find(:css, 'img[src^="/system/images"]')[:src]
          expect(page).to have_css('img[src*="/system/images"]')
          expect { page }.to_not have_content('Not found')
        end
      end

      context "destroy" do
        it "removes image" do
          visit refinery.admin_images_path
          expect(page).to have_selector("a[href='#{refinery.admin_image_path(image)}']")

          click_link ::I18n.t('delete', scope: 'refinery.admin.images')

          expect(page).to have_content(::I18n.t('destroyed', scope: 'refinery.crudify', what: "'Beach'"))
          expect(Refinery::Image.count).to eq(0)
        end
      end

      context "download" do
        it "succeeds" do
          visit refinery.admin_images_path

          expect { click_link "View this image" }.not_to raise_error
        end
      end

      describe "switch view" do
        it "shows images in grid" do
          visit refinery.admin_images_path
          expect(page).to have_content(::I18n.t('switch_to', view_name: 'list', scope: 'refinery.admin.images.index.view'))
          expect(page).to have_selector("a[href='#{refinery.admin_images_path(view: 'list')}']")

          click_link "Switch to list view"

          expect(page).to have_content(::I18n.t('switch_to', view_name: 'grid', scope: 'refinery.admin.images.index.view'))
          expect(page).to have_selector("a[href='#{refinery.admin_images_path(view: 'grid')}']")
        end
      end
    end
  end
end
