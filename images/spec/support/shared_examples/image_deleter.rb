shared_examples_for 'deletes an image' do
  before do
    raise 'please set let(:initial_path)' if initial_path.blank?
    ensure_on(initial_path)
  end

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}
  let(:deleting_an_image) {
    -> {
      first('#records li').click_link(::I18n.t('delete', scope: 'refinery.admin.images'))
    }
  }

  it 'every image can be deleted' do
    expect(page).to have_selector('#records.images li a.confirm-delete', count: image_count)
  end

  it 'deletes an image' do

    expect(deleting_an_image).to change(Refinery::Image, :count).by(-1)
    expect(page).to have_content(::I18n.t('destroyed', scope: 'refinery.crudify', what: ''))
  end
end
