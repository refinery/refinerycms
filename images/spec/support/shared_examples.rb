def upload_an_image(host_element, image, title='', alt='')
  host_element do
    attach_file "image_image", Refinery.roots('refinery/images').join('spec/fixtures').join(image)
    fill_in  'image_image_title', with: title
    fill_in  'image_image_alt', with: alt
    click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
  end
end

def image_upload_dialog()
end

def ensure_on(path)
  visit(path) unless current_path == path
end

shared_examples_for 'an image index' do |initial_path|

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}

  before do
    ensure_on(initial_path)
  end

  it 'shows all the images' do
    expect(page).to have_selector('#records.images li', count: image_count)
  end

  it 'makes the alt and title attribute of each image available' do
    expect(page).to have_selector('#records a[title^="Title:"]', count: image_count)
  end

  context "when in grid view" do

    before  do
      ensure_on(current_path + "?view=grid")
    end

    it 'shows the images with thumbnails' do
      expect(page).to have_selector('#records li>img', count: image_count)
    end

    it 'has an option to switch to list view' do
      expect(page).to have_content(::I18n.t('switch_to', view_name: 'list', scope: 'refinery.admin.images.index.view'))
    end

  end  # grid view

  context "when in list view" do

    before  do
      ensure_on(current_path + "?view=list")
    end

    it 'shows images by Title' do
      expect(page).to have_selector('#records li>span.title', count: image_count)
    end

    it 'has an option to switch to grid view' do
      ensure_on(current_path + '?view=list')

      expect(page).to have_content(::I18n.t('switch_to', view_name: 'grid', scope: 'refinery.admin.images.index.view'))
    end

  end # list view

  describe 'pagination', unless: Refinery::Image.count<=2 do
    Refinery::Images.pages_per_admin_index=2

    it 'divides the index into pages' do
      expect(page).to have_selector("div.pagination em.current")
    end

    context 'when on the first page' do
      it 'shows a link for the next page' do
        ensure_on(current_path + '?from_page=1&page=1')
        expect(page).to have_selector("a.next_page[rel='next']")
      end

      it 'has disabled the previous page link' do
        expect(page).to have_selector('.previous_page.disabled')
      end
    end

    context 'when on the last page' do
      it 'shows a link for the previous page' do
        ensure_on(current_path + '?from_page=1&page=2')
        expect(page).to have_selector("a.previous_page[rel='prev start']")
      end

      it 'has disabled the next link' do
        expect(page).to have_selector('.next_page.disabled')
      end

    end
  end  # pagination
end # image index

shared_examples_for 'an image deleter' do |initial_path|

  before  do
    ensure_on(initial_path)
  end
  let(:deleting_an_image) { -> { first("#records.images li").click_link(::I18n.t('delete', scope: 'refinery.admin.images'))  } }

  it 'has a delete image link for each image' do

  end

  it "removes an image" do
    expect(deleting_an_image).to change(Refinery::Image, :count).by(-1)
  end

  it 'says the image has been removed' do
    image_title = find("#records.images li:first-child span.title").text
    first("#records.images li").click_link(::I18n.t('delete', scope: 'refinery.admin.images'))
    expect(page).to have_content(::I18n.t('destroyed', scope: 'refinery.crudify', what: "'#{image_title}'"))
  end

end

shared_examples 'an image_uploader' do
  context 'always' do
    it "shows add new image link" do
    end
  end
  it 'shows the image upload dialog', js: true do
  end

  describe "It uploads an image" do
    upload_an_image(host_element, 'image-with-dashes.jpg')
    it "creates an image", js: true do
    end
    it "sets default title and alt attributes", js: true do
    end

    it 'uses supplied title and alt fields', js: true do
      upload_an_image('image-with-dashes.jpg', 'Image Title', 'Image Alt')
    end

    it 'reports success' do
    end
  end

  describe 'uploads multiple images', js: true do
    it 'will upload more than one image' do
    end

    it 'gives each image a different name' do
    end
  end

  describe "it will not upload a file that is not a defined image type", js: true do
    context 'no existing images' do
      upload_an_image('cape-town-tide-table.pdf')

      it 'does not create an image' do
      end

      it 'reports failure' do
      end


      context 'existing images', js: true do

        FactoryGirl.create(:image)
        visit refinery.insert_admin_images_path(modal: true)

        choose 'Upload'
        upload_an_image('cape-town-tide-table.pdf')
        it 'does not create an image' do
          expect(Refinery::Image.count).to eq(1)
        end
        it 'reports failure' do
          host_element do
            expect(dialog_element).to have_content(::I18n.t('incorrect_format', scope: 'activerecord.errors.models.refinery/image'))
          end
        end
      end
    end
  end

  shared_examples 'an image editor' do

  end

  shared_examples 'an image previewer' do

  end

      context "when images exist" do

        describe "it can delete images" do
          it "removes image" do
            visit refinery.admin_images_path
            expect(page).to have_selector("a[href='#{refinery.admin_image_path(image)}']")

            click_link ::I18n.t('delete', scope: 'refinery.admin.images')

            expect(page).to have_content(::I18n.t('destroyed', scope: 'refinery.crudify', what: "'Beach'"))
            expect(Refinery::Image.count).to eq(0)
          end
        end

        describe "download" do
          it "succeeds" do
            visit refinery.admin_images_path
            expect { click_link "View this image" }.not_to raise_error
          end
        end

        it_behaves_like 'an image_uploader' do
          host_element = page.within_frame('dialog_iframe')
          clickon = refinery.new_admin_images_path
        end
      end
    end

  describe "Upload an image from page editor", type: feature do

    it_behaves_like 'an image uploader' do
    end
  end

  describe "Edit or update an image" do

    context "edit/update" do
      it "updates image with a file of the same name" do
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

      it "won't update if image has different file name" do
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
        expect(page.body).to match(/Add Image/)
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
  end