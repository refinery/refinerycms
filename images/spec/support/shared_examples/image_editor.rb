shared_examples 'edits an image' do
  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  let(:uploading_a_good_image) {
    ->{
      first("#records li a.edit_icon").click
      attach_file 'image_image', valid_image_path
      fill_in  'image_image_title', with: 'Image With Dashes'
      fill_in  'image_image_alt', with: "Alt description for image"
      click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
    }
  }
  let(:uploading_a_bad_image) {
    ->{
      first("#records li a.edit_icon").click
      attach_file 'image_image', invalid_image_path
      fill_in  'image_image_title', with: 'Image With Dashes'
      fill_in  'image_image_alt', with: "Alt description for image"
      click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
    }
  }

  let(:valid_image_path) {Refinery.roots('refinery/images').join("spec/fixtures/beach.jpeg")}
  let(:invalid_image_path) {Refinery.roots('refinery/images').join("spec/fixtures/beach-alternate.jpeg")}
    
  it 'allows replacing an image with another of the same name', :js => true do
    expect(uploading_a_good_image).to_not change(Refinery::Image, :count)
    expect(page).to have_content(::I18n.t('updated',
      :scope => 'refinery.crudify',
      :what => "'Image With Dashes'"
    ))
  end
  it 'gracefully rejects replacing an image with another of a different name', :js => true do 
    expect(uploading_a_bad_image).to_not change(Refinery::Image, :count)
    expect(page).to have_content(::I18n.t('expected_filename',
      :scope => 'refinery.admin.images.form'
    ))
    expect(page).to have_content(::I18n.t('different_file_name',
      :scope => 'activerecord.errors.models.refinery/image'
    ))
  end
end