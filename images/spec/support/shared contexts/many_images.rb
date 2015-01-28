shared_context 'many images' do
  let!(:image) { FactoryGirl.create(:image) }
  let!(:alt_image) { FactoryGirl.create(:alternate_image) }
  let!(:another_image) { FactoryGirl.create(:another_image) }
end
