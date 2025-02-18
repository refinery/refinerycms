shared_examples_for 'Index' do

  let(:image_count) { [Refinery::Image.count, Refinery::Images.pages_per_admin_index].min }

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
end

shared_examples_for 'All Index Views' do
  it 'shows the alt attribute of each image if it different from the title', js: true do
    expect(page).to have_selector(image_alt, text: 'A Beach', count: 1)
  end

  it 'shows the title attribute of an image', js: true do
    expect(page).to have_selector(image_title, count: image_count)
  end

  it 'has an option to switch to another view', js: true do
    expect(page).to have_content(::I18n.t('switch_to', view_name: alt_view, scope: 'refinery.admin.images.index.view'))
  end
end

shared_examples_for 'Index Views' do
  let(:image_count) { [Refinery::Image.count, Refinery::Images.pages_per_admin_index].min }

  context "when in grid view" do
    init_index_view('grid') do
      it_behaves_like 'All Index Views'
      it 'shows thumbnails', js: true do
        expect(page).to have_selector(image_item, count: image_count)
      end
    end
  end # grid view

  context "when in list view" do
    init_index_view('list') do
      it_behaves_like 'All Index Views'
      it 'show filenames' do
        expect(page).to have_selector(filename, count: image_count)
      end
    end
  end

end

shared_examples_for 'Index Pagination' do
  let(:image_count) { [Refinery::Image.count, Refinery::Images.pages_per_admin_index].min }

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
    end # last page

  end # pagination

end # image index
