require "spec_helper"

module Refinery

  describe "Admin Images Tab", type: :feature do
    refinery_login_with :refinery_user
    include_context 'admin images tab'

    context 'when there are no images' do
      include_context 'no existing images'

      it 'says there are no images'do
        visit refinery.admin_images_path
        expect(page).to have_content(::I18n.t('no_images_yet', scope: 'refinery.admin.images.records'))
      end

      it_has_behaviour 'uploads images'
    end

    context 'when there is one image' do
      include_context 'one image'

      it_has_behaviour 'indexes images'
      it_has_behaviour 'shows list and grid views'
      it_has_behaviour 'shows an image preview'
      it_has_behaviour 'deletes an image'
      it_has_behaviour 'uploads images'
    end

    context 'when there are many images' do
      include_context 'many images'

      it_has_behaviour 'indexes images'
      it_has_behaviour 'shows list and grid views'
      it_has_behaviour 'paginates the list of images'
      it_has_behaviour 'shows an image preview'
      it_has_behaviour 'deletes an image'
      it_has_behaviour 'uploads images'
    # it_has_behaviour 'edits an image'
    end

  end

  describe 'Page Edit tab - Insert Image', type: :feature do
    refinery_login_with :refinery_user

    include_context 'Visual Editor - add image'

    around(:each) do
      page.within_frame(dialog_frame_id) do

        context 'when there are no images' do
          include_context 'no existing images'
          it_has_behaviour 'uploads images'
        end

        context 'when there is one image' do
          include_context 'one image'

          it_has_behaviour 'indexes images'
          it_has_behaviour 'paginates the list of images'
          it_has_behaviour 'uploads images'
        end

        context 'when there are many images' do
          include_context 'many images'

          it_has_behaviour 'indexes images'
          it_has_behaviour 'paginates the list of images'
          it_has_behaviour 'uploads images'
        end
      end
    end

  end
end