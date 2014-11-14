shared_examples_for 'an image index' do

  let(:image_count) {[Refinery::Image.count, Refinery::Images.pages_per_admin_index].min}

  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end


  it 'shows all the images' do
    expect(page).to have_selector('#records.images li', count: image_count)
  end

  it 'makes the title attribute of each image available' do
    expect(page).to have_selector('#records a[title^="Title:"]', count: image_count)
  end

  it 'makes the alt attribute of each image available' do
    expect(page).to have_selector('#records a[alt"]', count: image_count)
  end

  context ''


end # image index