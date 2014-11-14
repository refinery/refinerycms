require "spec_helper"

module Refinery

  describe "Admin Images Tab", type: :feature do
    refinery_login_with :refinery_user

    context 'when there are no images' do
      let(:open_image_dialog) { click_on(::I18n.t('create_new_image', :scope => 'refinery.admin.images.actions')) }
      let(:dialog_frame_id) {'dialog_iframe'}
      let(:initial_path) { refinery.admin_images_path(view: %w(grid list).sample) }

      it 'says there are no images'do
        visit refinery.admin_images_path
        expect(page).to have_content(::I18n.t('no_images_yet', scope: 'refinery.admin.images.records'))
      end

      it_behaves_like 'an image uploader'
    end

    context 'when there is one image' do
      let(:open_image_dialog) { click_on(::I18n.t('create_new_image', :scope => 'refinery.admin.images.actions')) }
      let(:dialog_frame_id) {'dialog_iframe'}
      let!(:image) { FactoryGirl.create(:image) }
      let(:initial_path) { refinery.admin_images_path(view: %w(grid list).sample) }

      it_behaves_like 'an image index'
      it_has_behaviour 'shows list and grid views'
      it_behaves_like 'an image previewer'
      it_behaves_like 'an image deleter'
      it_behaves_like 'an image uploader'
    end

    context 'when there are many images' do
      let(:open_image_dialog) { click_on(::I18n.t('create_new_image', :scope => 'refinery.admin.images.actions')) }
      let(:dialog_frame_id) {'dialog_iframe'}
      let!(:image) { FactoryGirl.create(:image) }
      let!(:alt_image) { FactoryGirl.create(:alternate_image) }
      let!(:another_image) { FactoryGirl.create(:another_image) }
      let(:initial_path) { refinery.admin_images_path(view: %w(grid list).sample) }

      it_behaves_like 'an image index'
      it_has_behaviour 'shows list and grid views'
      it_has_behaviour 'paginates the list of images'
      it_behaves_like 'an image previewer'
      it_behaves_like 'an image deleter'
      it_behaves_like 'an image uploader'
     # it behaves_like 'an image editor'
     end

  end

  describe 'Page Edit tab - Insert Image', type: :feature do
    refinery_login_with :refinery_user

    let(:page_for_image) {
      page = Refinery::Page.create :title => "Add Image to me"
      # we need page parts so that there's a visual editor
      Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
        page.parts.create(:title => default_page_part, :body => nil, :position => index)
      end
    page
    }

    context 'when there are no images' do
      let!(:image) { FactoryGirl.create(:image) }
      let(:initial_path) {refinery.edit_admin_page_path(page_for_image)}
      let(:open_image_dialog) { click_link("Add Image") }
      let(:select_upload) {choose(::I18n.t('new_image', :scope => 'refinery.admin.images.insert')) }
      let(:dialog_frame_id) {'dialog_frame'}

      it_behaves_like 'an image uploader'
    end

    context 'when there is one image' do
      let!(:image) { FactoryGirl.create(:image) }
      let(:initial_path) {refinery.edit_admin_page_path(page_for_image)}
      let(:open_image_dialog) { click_link("Add Image") }
      let(:select_upload) {choose(::I18n.t('new_image', :scope => 'refinery.admin.images.insert')) }
      let(:dialog_frame_id) {'dialog_frame'}

      it_behaves_like 'an image index'
      it_has_behaviour 'paginates the list of images'
      it_behaves_like 'an image uploader'
    end

    context 'when there are many images' do
      let!(:image) { FactoryGirl.create(:image) }
      let!(:alt_image) { FactoryGirl.create(:alternate_image) }
      let!(:another_image) { FactoryGirl.create(:another_image) }
      let(:initial_path) {refinery.edit_admin_page_path(page_for_image)}
      let(:open_image_dialog) { click_link("Add Image") }
      let(:select_upload) {choose(::I18n.t('new_image', :scope => 'refinery.admin.images.insert')) }
      let(:dialog_frame_id) {'dialog_frame'}

      it_behaves_like 'an image index'
      it_has_behaviour 'paginates the list of images'
      it_behaves_like 'an image previewer'
      it_behaves_like 'an image deleter'
      it_behaves_like 'an image uploader'
     end

  end
end