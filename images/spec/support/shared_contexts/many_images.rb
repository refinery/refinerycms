shared_context 'many images' do
  let!(:image) { FactoryBot.create(:image) }
  let!(:alt_image) { FactoryBot.create(:alternate_image) }
  let!(:another_image) { FactoryBot.create(:another_image) }
end
