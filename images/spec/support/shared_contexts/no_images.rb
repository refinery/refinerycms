shared_context "no existing images" do
  Refinery::Image.delete_all
 let(:image) { FactoryBot.create(:image) }
end
