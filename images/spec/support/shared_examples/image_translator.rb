shared_examples 'translates an image' do
  before do
    allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :fr])
    ensure_on(initial_path)
  end

  context "when in list view" do
    before  do
      ensure_on(current_path + "?view=list")
    end

    it "can have a second locale added to it" do
      expect(page).to have_content("Beach")
      expect(page).to have_selector("a[href='/refinery/images/#{image.id}/edit']")

      click_link "Edit this image"

      within "#switch_locale_picker" do
        click_link "FR"
      end

      fill_in "Title", :with => "Titre de la première image"
      fill_in "Alt", :with => "Texte alternatif de la première image"

      click_button "Save"

      expect(page).to have_content("'Titre de la première image' was successfully updated.")
      expect(Refinery::Image.translation_class.count).to eq(1)
    end
  end
end
