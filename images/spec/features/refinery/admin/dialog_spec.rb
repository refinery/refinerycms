require "spec_helper"

module Refinery
  describe "dialog", :type => :feature do
    refinery_login

    context 'When there are many images' do
      include_context 'many images'

      it "does not have selected an image" do
        visit refinery.insert_admin_images_path

        expect(page).to_not have_selector("li[class='selected']")
      end

      it "only selects the provided image" do
        visit refinery.insert_admin_images_path(selected_image: 1)

        expect(page).to have_selector("li[class='selected'] img[data-id='1']")
        expect(page).to_not have_selector("li[class='selected'] img[data-id='2']")
        expect(page).to_not have_selector("li[class='selected'] img[data-id='3']")
      end
    end
  end
end
