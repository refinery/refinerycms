shared_examples_for 'shows list and grid views' do

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}

  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  context "when in grid view" do

    before { ensure_on(current_path + "?view=grid") }

    it 'shows the images with thumbnails' do
      expect(page).to have_selector('#records li>img', count: image_count)
    end

    it 'has an option to switch to list view' do
      expect(page).to have_content(::I18n.t('switch_to', view_name: 'list', scope: 'refinery.admin.images.index.view'))
    end

  end  # grid view

  context "when in list view" do

    before  do
      ensure_on(current_path + "?view=list")
    end

    it 'shows images by Title' do
      expect(page).to have_selector('#records li>span.title', count: image_count)
    end

    it 'has an option to switch to grid view' do
      ensure_on(current_path + '?view=list')

      expect(page).to have_content(::I18n.t('switch_to', view_name: 'grid', scope: 'refinery.admin.images.index.view'))
    end

  end # list view
end