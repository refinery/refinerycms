shared_examples 'uploads images' do
  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
    initialize_context
  end

  let(:uploading_an_image) {
  ->{
    open_upload_dialog
    page.within_frame(dialog_frame_id) do
      select_upload
      attach_file 'image_image', image_path
      fill_in  'image_image_title', with: 'Image With Dashes'
      fill_in  'image_image_alt', with: "Alt description for image"
      click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
    end
    }
  }

  context 'when the image type is acceptable' do
    let(:image_path) {Refinery.roots('refinery/images').join("spec/fixtures/image-with-dashes.jpg")}
    it 'the image is uploaded', :js => true do
      expect(uploading_an_image).to change(Refinery::Image, :count).by(1)
    end
  end

  context 'when the image type is not acceptable' do
    let(:image_path) {Refinery.roots('refinery/images').join("spec/fixtures/cape-town-tide-table.pdf")}
    it 'the image is rejected', :js => true do
      expect(uploading_an_image).to_not change(Refinery::Image, :count)
      page.within_frame(dialog_frame_id) do
        expect(page).to have_content(::I18n.t('incorrect_format', :scope => 'activerecord.errors.models.refinery/image'))
      end
    end
  end
end
