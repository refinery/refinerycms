shared_examples_for 'indexes images' do

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}

  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
    initialize_context
  end

  it 'shows all the images', js: true do
    if index_in_frame
      page.within_frame(dialog_frame_id) do
        expect(page).to have_selector(index_item_selector, count: image_count)
      end
    else
      expect(page).to have_selector(index_item_selector, count: image_count)
    end
  end

end # image index

shared_examples_for 'shows list and grid views' do

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}

  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  context "when in grid view" do

    before { ensure_on(current_path + "?view=grid") }

    it 'shows the images with thumbnails', js: true do
      expect(page).to have_selector(index_item_selector << gridview_img_selector, count: image_count)
    end

    it 'makes the title attribute of each image available', js: true do
      expect(page).to have_selector(index_item_selector << gridview_img_selector << gridview_title_selector, count: image_count)
    end

    it 'makes the alt attribute of each image available', js: true do
      expect(page).to have_selector(index_item_selector << gridview_img_selector << gridview_alt_selector, count: image_count)
    end

    it 'has an option to switch to list view' do
      expect(page).to have_content(::I18n.t('switch_to', view_name: 'list', scope: 'refinery.admin.images.index.view'))
    end

  end  # grid view

  context "when in list view" do

    before  do
      ensure_on(current_path + "?view=list")
    end

    it 'makes the title attribute of each image available', js: true do
      expect(page).to have_selector(index_item_selector <<  listview_title_selector, count: image_count)
    end

    it 'makes the filename of each image available' do
      expect(page).to have_selector(index_item_selector << listview_filename_selector, count: image_count)
    end

    it 'has an option to switch to grid view' do
      ensure_on(current_path + '?view=list')

      expect(page).to have_content(::I18n.t('switch_to', view_name: 'grid', scope: 'refinery.admin.images.index.view'))
    end

  end # list view
end

shared_examples_for 'paginates the list of images' do

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}

  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  describe 'pagination', unless: Refinery::Image.count <= 2 do
    before {
      Refinery::Images.pages_per_admin_index = 2
      Refinery::Images.pages_per_dialog_that_have_size_options = 2 }

    it 'divides the index into pages' do
      expect(page).to have_selector("div.pagination em.current")
    end

    context 'when on the first page' do
      it 'shows a link for the next page' do
        ensure_on(current_path + '?from_page=1&page=1')
        expect(page).to have_selector("a.next_page[rel='next']")
      end

      it 'has disabled the previous page link' do
        expect(page).to have_selector('.previous_page.disabled')
      end
    end

    context 'when on the last page' do
      it 'shows a link for the previous page' do
        ensure_on(current_path + '?from_page=1&page=2')
        expect(page).to have_selector("a.previous_page[rel='prev start']")
      end

      it 'has disabled the next link' do
        expect(page).to have_selector('.next_page.disabled')
      end

    end
  end  # pagination
end # image index
