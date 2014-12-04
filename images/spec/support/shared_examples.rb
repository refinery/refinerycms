def ensure_on(path)
  visit(path) unless current_path == path
end

shared_examples_for 'an image index' do

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}

  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  it 'shows all the images' do
    expect(page).to have_selector('#records.images li', count: image_count)
  end

  it 'makes the alt and title attribute of each image available' do
    expect(page).to have_selector('#records a[title^="Title:"]', count: image_count)
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

  describe 'pagination', unless: Refinery::Image.count <= 2 do
    before { Refinery::Images.pages_per_admin_index = 2 }

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

shared_examples_for 'an image deleter' do
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

shared_examples 'an image uploader' do
  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  let(:uploading_an_image) {
    -> {
        click_link ::I18n.t('create_new_image', :scope => 'refinery.admin.images.actions')
        page.within_frame('dialog_iframe') do
          attach_file 'image_image', image_path
          fill_in  'image_image_title', with: 'Image With Dashes'
          fill_in  'image_image_alt', with: "Alt description for image"
          click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
        end
    }
  }

  context 'the image type is acceptable' do
    let(:image_path) {Refinery.roots('refinery/images').join("spec/fixtures/image-with-dashes.jpg")}
    it 'uploads an image', :js => true do
      expect(uploading_an_image).to change(Refinery::Image, :count).by(1)
      expect(page).to have_content(::I18n.t('created', :scope => 'refinery.crudify', :what => "'Image With Dashes'"))
    end
  end

  context 'the image type is not acceptable' do
    let(:image_path) {Refinery.roots('refinery/images').join("spec/fixtures/cape-town-tide-table.pdf")}
    it 'rejects the image', :js => true do
      expect(uploading_an_image).to_not change(Refinery::Image, :count)
      page.within_frame('dialog_iframe') do
        expect(page).to have_content(::I18n.t('incorrect_format', :scope => 'activerecord.errors.models.refinery/image'))
      end
    end
  end
end

shared_examples 'an image editor' do
end

shared_examples 'an image previewer' do
end
