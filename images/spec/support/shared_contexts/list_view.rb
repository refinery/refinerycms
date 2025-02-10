shared_context 'list view' do
  let(:initial_path) { refinery.admin_images_path + '?view=list' }
  let(:img_selector) { '' }
  let(:alt_selector) { 'span.alt' }
  let(:title_selector) { 'a.edit_link' }
  let(:image_title) { [index_item_selector, title_selector].join(' ') }
  let(:view_selector) {'#image_index.list'}

  let(:filename_selector) { '.filename' }
  let(:filename) { [index_item_selector, filename_selector ].join(' ') }
  let(:alt_view) {'grid'}
end
