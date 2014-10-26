require "spec_helper"

module Refinery

  describe "Admin Images Tab", type: :feature do
    refinery_login_with :refinery_user

    context 'when there are no images' do
      let(:initial_path) { refinery.admin_images_path(view: %w(grid list).sample) }
      it 'says there are no images'do
        visit refinery.admin_images_path
        expect(page).to have_content(::I18n.t('no_images_yet', scope: 'refinery.admin.images.records'))
      end

      it_behaves_like 'an image uploader'
    end

    context 'when there is one image' do
      let!(:image) { FactoryGirl.create(:image) }
      let(:initial_path) { refinery.admin_images_path(view: %w(grid list).sample) }

      it_behaves_like 'an image index'
      it_behaves_like 'an image deleter'
      it_behaves_like 'an image uploader'
    end

    context 'when there are many images' do
      let!(:image) { FactoryGirl.create(:image) }
      let!(:alt_image) { FactoryGirl.create(:alternate_image) }
      let!(:another_image) { FactoryGirl.create(:another_image) }
      let(:initial_path) { refinery.admin_images_path(view: %w(grid list).sample) }

      it_behaves_like 'an image index'
      it_behaves_like 'an image deleter'
      it_behaves_like 'an image uploader'
    end

  end

  describe 'Page Edit Images tab' do
    # it_behaves_like 'an image uploader'
    # it behaves_like 'an image editor'
    # it behaves_like 'an image previewer'
    # it_behaves_like 'an image index'
    # it behaves_like 'an image inserter'
    # it behaves_like 'an image deleter'
  end

end
