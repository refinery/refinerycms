def upload_an_image(host_element, image, title='', alt='')
  attach_file "image_image", Refinery.roots('refinery/images').join('spec/fixtures').join(image)
  fill_in  'image_image_title', with: title
  fill_in  'image_image_alt', with: alt
  click_button ::I18n.t('save', scope: 'refinery.admin.form_actions')
end

def image_upload_dialog()
end

def ensure_on(path)
  visit(path) unless current_path == path
end

shared_examples_for 'an image index' do |initial_path|

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}

  before do
    ensure_on(initial_path)
  end

  it 'shows all the images' do
    expect(page).to have_selector('#records.images li', count: image_count)
  end

  it 'makes the alt and title attribute of each image available' do
    expect(page).to have_selector('#records a[title^="Title:"]', count: image_count)
  end

  context "when in grid view" do

    before  do
      ensure_on(current_path + "?view=grid")
    end

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

  describe 'pagination', unless: Refinery::Image.count<=2 do
    Refinery::Images.pages_per_admin_index=2

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

shared_examples_for 'an image deleter' do |initial_path|

  before  do
    ensure_on(initial_path)
  end
  let(:deleting_an_image) { -> { first("#records li").click_link(::I18n.t('delete', scope: 'refinery.admin.images'))  } }

  it 'has a delete image link for each image' do

  end

  it "removes an image" do
    expect(deleting_an_image).to change(Refinery::Image, :count).by(-1)
  end

  it 'says the image has been removed' do
    expect(page).to have_selector("#records li.image_0")
    image_list_item = find("#records li.image_0")
    image_title = image_list_item.first("img")[:title]
    first("#records li").click_link(::I18n.t('delete', scope: 'refinery.admin.images'))
    expect(page).to have_content(::I18n.t('destroyed', scope: 'refinery.crudify', what: "'#{image_title}'"))
  end

end

shared_examples 'an image uploader' do
end

shared_examples 'an image editor' do
end

shared_examples 'an image previewer' do
end

