shared_context 'admin images tab' do
  let(:initial_path){refinery.admin_images_path}
  let(:open_upload_dialog) { find('a', text: ::I18n.t('create_new_image', scope: 'refinery.admin.images.actions')).click }
  let(:select_upload) {}
  let(:initialize_context) {}
  let(:index_in_frame) {false}
  let(:dialog_frame_id) {'dialog_iframe'}

  let(:index_item_selector) {'#records li'}
  let(:image_item) { [index_item_selector, img_selector].join(' ') }
  let(:image_title) { [index_item_selector, title_selector].join(' ') }
  let(:image_alt) { [index_item_selector, alt_selector ].join(' ') }
end
