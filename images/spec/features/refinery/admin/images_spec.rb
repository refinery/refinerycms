require "spec_helper"

module Refinery
  describe "the Admin Images Tab", type: :feature do
    refinery_login
    include_context 'admin images tab'

    context 'When there are no images' do
      include_context 'no existing images'

      it 'says there are no images' do
        visit refinery.admin_images_path
        expect(page).to have_content(::I18n.t('no_images_yet', scope: 'refinery.admin.images.records'))
      end

      it_has_behaviour 'uploads images'
    end

    context 'When there is one image' do
      include_context 'one image'

      it_has_behaviour 'indexes images'
      it_has_behaviour 'shows list and grid views'
      it_has_behaviour 'shows an image preview'
      it_has_behaviour 'deletes an image'
      it_has_behaviour 'edits an image'
      it_has_behaviour 'uploads images'
      it_has_behaviour 'translates an image'
    end

    context 'When there are many images' do
      include_context 'many images'

      it_has_behaviour 'indexes images'
      it_has_behaviour 'shows list and grid views'
      it_has_behaviour 'paginates the list of images'
      it_has_behaviour 'shows an image preview'
      it_has_behaviour 'deletes an image'
      it_has_behaviour 'uploads images'
      it_has_behaviour 'edits an image'
    end
  end

  describe 'Page Visual Editor - Add Image' do

    refinery_login

    include_context 'Visual Editor - add image'

    context 'When there are no images' do
      include_context 'no existing images'
      it_has_behaviour 'uploads images'
    end

    context 'When there is one image' do
      include_context 'one image'

      it_has_behaviour 'indexes images'
      it_has_behaviour 'paginates the list of images'
      it_has_behaviour 'uploads images'
      it_has_behaviour 'inserts images'
    end

    context 'When there are many images' do
      include_context 'many images'

      it_has_behaviour 'indexes images'
      it_has_behaviour 'paginates the list of images'
      it_has_behaviour 'uploads images'
      it_has_behaviour 'inserts images'
    end

  end
end
