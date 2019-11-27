require "spec_helper"

module Refinery
  describe "dialog", :type => :system do
    refinery_login

    context 'When there are many images' do
      include_context 'many images'

      it "does not have selected an image" do
        visit refinery.insert_admin_images_path

        expect(page).to_not have_selector("li[class='selected']")
      end

      it "only selects the provided image" do
        visit refinery.insert_admin_images_path(selected_image: image.id)

        expect(page).to have_selector("li[class='selected'] img[data-id='#{image.id}']")
        expect(page).to_not have_selector("li[class='selected'] img[data-id='#{alt_image.id}']")
        expect(page).to_not have_selector("li[class='selected'] img[data-id='#{another_image.id}']")
      end
    end
  end
end
