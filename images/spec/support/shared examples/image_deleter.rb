shared_examples_for 'deletes an image' do
  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}
  let(:deleting_an_image) {
    -> {
      first("#records li").click_link(::I18n.t('delete', scope: 'refinery.admin.images'))
    }
  }

  it 'has a delete image link for each image' do
    expect(page).to have_selector('#records.images li a.confirm-delete', count: image_count)
  end

  it "removes an image" do
    expect(deleting_an_image).to change(Refinery::Image, :count).by(-1)
  end

  it 'says the image has been removed' do
    expect(page).to have_selector(".images_list li:first")
    image_title = find(".images_list li:first").first("img")[:title] || # grid view
                  find(".images_list li:first").first("span.title").text # list view
    expect(image_title).to be_present

    first(".images_list li:first").click_link(::I18n.t('delete', scope: 'refinery.admin.images'))
    expect(page).to have_content(::I18n.t('destroyed', scope: 'refinery.crudify', what: "'#{image_title}'"))
  end

end
