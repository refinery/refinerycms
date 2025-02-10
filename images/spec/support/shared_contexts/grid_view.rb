shared_context 'grid view' do
  let(:initial_path) { refinery.admin_images_path + '?view=grid' }
  let(:img_selector) { '> a img' }
  let(:alt_selector) { 'span.alt' }
  let(:title_selector) { 'span.title' }
  let(:view_selector) {'#image_index.grid'}
  let(:alt_view) {'list'}
end
