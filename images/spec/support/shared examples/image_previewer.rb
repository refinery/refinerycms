def preview_image
  preview_window = window_opened_by do
    image_url
    find(:linkhref, image_url).click
  end

  page.within_window preview_window do
    expect(page).to have_image(image_url)
  end
  preview_window.close
end

shared_examples 'shows an image preview' do
  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  let(:image_url) {first(:xpath, "//a[@class=' preview_icon']")[:href]}

  context "when in list view" do
    before  do
      ensure_on(current_path + "?view=list")
    end

    it 'displays the image in a new window', js: true do
      preview_image()
    end
  end


    context "when in grid view" do
    before  do
      ensure_on(current_path + "?view=grid")
    end

    it 'displays the image in a new window', js: true do
      preview_image
    end
  end
end