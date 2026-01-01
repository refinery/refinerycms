shared_context 'Visual Editor - add image' do

  let(:page_for_image) {
    page = Refinery::Page.create :title => "Add Image to me"
    # we need page parts so that there's a visual editor
    Refinery::Pages.default_parts.each_with_index do |default_page_part, index|
      page.parts.create(:title => default_page_part, :slug => default_page_part, :body => nil, :position => index)
    end
    page
  }

  let(:initialize_context) {click_on('Add Image') }

  let(:open_upload_dialog) {}
  let(:select_upload) {choose(::I18n.t('new_image', :scope => 'refinery.admin.images.insert')) }

  let(:initial_path) { refinery.edit_admin_page_path(page_for_image) }

  # let(:target_image) { find(:xpath, "//img[@title='Beach']")}
  # let(:url){target_image["data-#{size}"]}

  let(:index_in_frame)  {true}
  let(:dialog_frame_id) {'dialog_frame'}
  let(:index_item_selector) {'#existing_image_area_content ul li img'}
  let(:title_attribute_selector) {'[title]'}
  let(:alt_attribute_selector) {'[alt]'}

  let(:image_title_selector) {|title| '//img[@alt="' << title << '"]'}
  let(:image_size_selector)  {|size| '//a[@href="#' << size << '"]'}

end
