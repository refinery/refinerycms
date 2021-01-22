shared_context "one image" do
  Refinery::Image.delete_all
 let!(:image) { FactoryBot.create(:image) }
end
