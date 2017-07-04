require "spec_helper"

module Refinery
  describe "Crudify", type: :feature do
    refinery_login

    describe "xhr_paging", :js do
      # Refinery::Admin::ImagesController specifies :order => 'created_at DESC' in crudify
      let(:first_image) { Image.order('created_at DESC').first }
      let(:last_image) { Image.order('created_at DESC').last }
      let!(:image_1) { FactoryGirl.create :image }
      let!(:image_2) { FactoryGirl.create :image }

      before do
        allow(Image).to receive(:per_page).and_return(1)
      end

      it 'performs ajax paging of index' do
        visit refinery.admin_images_path

        expect(page).to have_selector('ul#image_grid li > img', count: 1)
        expect(page).to have_css(%Q{img[alt="#{first_image.title}"]})

        # placeholder which would disappear in a full page refresh.
        page.evaluate_script("node = document.createElement('i');")
        page.evaluate_script("node.id = 'has_not_refreshed_entire_page';")
        page.evaluate_script("document.body.appendChild(node);")

        within '.pagination' do
          click_link '2'
        end

        expect(page).to have_css(%Q{img[alt="#{last_image.title}"]})
        expect(page.evaluate_script(
          %{$('i#has_not_refreshed_entire_page').length}
        )).to eq(1)
      end
    end
  end

end
