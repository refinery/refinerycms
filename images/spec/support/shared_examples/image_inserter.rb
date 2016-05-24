
shared_examples 'inserts images' do
  before do
    raise "please set let(:initial_path)" if initial_path.blank?
    ensure_on(initial_path)
  end

  def select_and_insert_image(title, size='medium')
    page.within_frame(dialog_frame_id) do
      within '#existing_image_area_content' do
        find(:xpath, "//img[@alt=\"#{title}\"]").click
        find(:xpath, "//a[@href=\"##{size}\"]").click
        find(:xpath, '//input[@id="submit_button"]').click
      end
    end
  end

  describe 'resize the image' do
    pending
    # it 'inserts an image of the selected size', js: true do
      # click_on('Add Image')
      # select_and_insert_image('Beach','large')
        # sleep 10
        # puts page.html
        # page.within_frame(find(:xpath, '//iframe[contains(@id,"WYMeditor")]')) do
          # expect(page).to have_selector('img[title="Beach"][data-rel*="450x450"]')
      # end
    # end
  end

  context 'when all images are available' do
    pending
    # it 'inserts the image into the page', js: true do
      # click_on('Add Image')
      # select_and_insert_image('Beach')
      # expect(page).to have_image(url)
    # end
  end

  context "when images are filtered by a search" do
    pending

    # before do
      # fill_in "search", :with => "Beach"
      # click_button "Search"
    # end
    # it 'inserts the image into the page', js: true do
      # click_on('Add Image')
      # select_and_insert_image('Beach')
      # expect(page).to have_image(url)
    # end
  end
end
