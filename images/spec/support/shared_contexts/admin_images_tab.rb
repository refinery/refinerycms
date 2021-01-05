shared_context 'admin images tab' do

  let(:open_upload_dialog) { find('a', text: ::I18n.t('create_new_image', scope: 'refinery.admin.images.actions')).click }
  let(:select_upload) {}
  let(:initialize_context) {}
  let(:index_in_frame) {false}
  let(:dialog_frame_id) {'dialog_iframe'}
  let(:initial_path) { refinery.admin_images_path(view: %w(grid list).sample) }

  let(:index_item_selector) {'#records li'}
  let(:gridview_img_selector) {'> a > img'}
  let(:gridview_title_selector) {' .actions a.info_icon[tooltip]'}
  let(:gridview_alt_selector) {' [alt]'}
  let(:listview_title_selector) {' > a.title'}
  let(:listview_filename_selector) {' > span.preview'}

end
