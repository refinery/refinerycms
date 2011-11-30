require 'spec_helper'

module Refinery
  module Admin
    describe ImagesController do
      describe "#images_from_params" do
        let(:images) do
          ["beach.jpeg", "id-rather-be-here.jpg"].map do |file|
            Rack::Test::UploadedFile.new(
              Refinery.roots(:'refinery/images').join("spec/fixtures/#{file}"),
              "image/jpeg",
            )
          end
        end

        before do
          controller.stub(:params => params)
        end

        subject { controller.send(:images_from_params) }

        context "with no images" do
          let(:params) do
            { :image => { :alt => "batman" } }
          end

          it "does not create an image" do
            image = subject.first
            image.should_not be_persisted
            image.alt.should eq("batman")
          end
        end

        context "with one image" do
          let(:params) do
            { :image => { :alt => "superman", :image => [images.first] } }
          end

          it "creates an image" do
            image = subject.first
            image.should be_persisted
            image.image_name.should eq("beach.jpeg")
            image.alt.should eq("superman")
          end
        end

        context "with multiple images" do
          let(:params) do
            { :image => { :alt => "aquaman", :image => images } }
          end

          it "creates multiple images" do
            one, two = subject

            one.should be_persisted
            one.image_name.should eq("beach.jpeg")
            one.alt.should eq("aquaman")

            two.should be_persisted
            two.image_name.should eq("id-rather-be-here.jpg")
            two.alt.should eq("aquaman")
          end
        end
      end
    end
  end
end
