shared_context 'many images' do
  let!(:image) { FactoryBot.create(:image, image_alt: "A Beach", image_title: "Peachy Beachy") }
  let!(:alt_image) { FactoryBot.create(:alternate_image) }
  let!(:another_image) { FactoryBot.create(:another_image) }
end
