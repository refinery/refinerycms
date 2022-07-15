require "spec_helper"

module Refinery
  describe "the Admin Images Tab", type: :system do
    refinery_login
    include_context 'admin images tab'

    context 'When there are no images' do
      include_context 'no existing images'

      it 'says there are no images' do
        visit refinery.admin_images_path
        expect(page).to have_content(::I18n.t('no_images_yet', scope: 'refinery.admin.images.records'))
      end

      it_has_behaviour 'Upload'
    end

    context 'When there is one image' do
      include_context 'one image'

      it_has_behaviour 'Index'
      it_has_behaviour 'Index Views'
      it_has_behaviour 'Preview'
      it_has_behaviour 'Delete'
      it_has_behaviour 'Edit'
      it_has_behaviour 'Upload'
      it_has_behaviour 'Translate'
    end

    context 'When there are many images' do
      include_context 'many images'

      it_has_behaviour 'Index'
      it_has_behaviour 'Index Views'
      it_has_behaviour 'Index Pagination'
      it_has_behaviour 'Preview'
      it_has_behaviour 'Delete'
      it_has_behaviour 'Upload'
      it_has_behaviour 'Edit'
    end
  end

  describe 'Page Visual Editor - Add Image' do

    refinery_login

    include_context 'Visual Editor - add image'

    context 'When there are no images' do
      include_context 'no existing images'
      it_has_behaviour 'Upload'
    end

    context 'When there is one image' do
      include_context 'one image'

      it_has_behaviour 'Index'
      it_has_behaviour 'Index Pagination'
      it_has_behaviour 'Upload'
      it_has_behaviour 'Insert'
    end

    context 'When there are many images' do
      include_context 'many images'

      it_has_behaviour 'Index'
      it_has_behaviour 'Index Pagination'
      it_has_behaviour 'Upload'
      it_has_behaviour 'Insert'
    end

  end
end
