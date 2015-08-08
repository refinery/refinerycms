require 'spec_helper'

module Refinery
  describe Image, :type => :model do

    let(:image)         { FactoryGirl.build(:image) }
    let(:created_image) { FactoryGirl.create(:image) }
    let(:titled_image)  { FactoryGirl.create(:image, image_title: 'Image Title')}
    let(:image_with_alt_text) { FactoryGirl.create(:image, image_alt: 'Alt Text')}
    let(:image_with_sha) {FactoryGirl.create(:image)}
    let(:image_without_sha) {FactoryGirl.create(:image)}

    describe "validations" do
      describe "valid #image" do
        before do
          @file = Refinery.roots('refinery/images').join("spec/fixtures/beach.jpeg")
          allow(Images).to receive(:max_image_size).and_return(File.read(@file).size + 10.megabytes)
        end

        it "should be valid when size does not exceed .max_image_size" do
          expect(Image.new(:image => @file)).to be_valid
        end
      end

      describe "too large #image" do
        before do
          @file = Refinery.roots('refinery/images').join("spec/fixtures/beach.jpeg")
          allow(Images).to receive(:max_image_size).and_return(0)
          @image = Image.new(:image => @file)
        end

        it "should not be valid when size exceeds .max_image_size" do
          expect(@image).not_to be_valid
        end

        it "should contain an error message" do
          @image.valid?
          expect(@image.errors).not_to be_empty
          expect(@image.errors[:image]).to eq(["Image should be smaller than #{Images.max_image_size} bytes in size"])
        end
      end

      describe "invalid argument for #image" do
        before do
          @image = Image.new
        end

        it "has an error message" do
          @image.valid?
          expect(@image.errors).not_to be_empty
          expect(@image.errors[:image]).to eq(["You must specify an image for upload"])
        end
      end

      context "when image exists" do
        it "doesn't allow to replace it with image which has different file name" do
          created_image.image = Refinery.roots('refinery/images').join("spec/fixtures/beach-alternate.jpeg")
          expect(created_image).not_to be_valid
          expect(created_image.errors.messages[:image_name].size).to be >= 1
        end

        it "allows to replace it with image which has the same file name" do
          created_image.image = Refinery.roots('refinery/images').join("spec/fixtures/beach.jpeg")
          expect(created_image).to be_valid
        end
      end
    end

    describe "image url" do
      it "responds to .thumbnail" do
        expect(image).to respond_to(:thumbnail)
      end

      it "contains its filename at the end" do
        expect(created_image.url.split('/').last).to match(/\A#{created_image.image_name}/)
      end

      it "becomes different when supplying geometry" do
        expect(created_image.url).not_to eq(created_image.thumbnail(:geometry => '200x200').url)
      end

      it "has different urls for each geometry string" do
        expect(created_image.thumbnail(:geometry => '200x200').url).not_to eq(created_image.thumbnail(:geometry => '200x201').url)
      end

      it "doesn't call thumb when geometry is nil" do
        expect(created_image.image).not_to receive(:thumb)
        created_image.thumbnail(geometry: nil)
      end

      it "uses right geometry when given a thumbnail name" do
        name, geometry = Refinery::Images.user_image_sizes.first
        expect(created_image.thumbnail(:geometry => name).url).to eq(created_image.thumbnail(:geometry => geometry).url)
      end

      it "can strip a thumbnail" do
        expect(created_image.thumbnail(:strip => true).url.blank?).to eq(false)
      end

      it "can resize and strip a thumbnail" do
        expect(created_image.thumbnail(:geometry => '200x200', :strip => true).url.blank?).to eq(false)
      end

    end

    describe "#title" do
      context 'when a specific title has not been given' do
        it "returns a titleized version of the filename" do
          expect(image.title).to eq("Beach")
        end
      end
      context 'when a specific title has been given' do
        it 'returns that title' do
          expect(titled_image.title).to eq('Image Title')
        end
      end
    end

    describe "#alt" do
      context 'when no alt attribute is given' do
        it "returns the title" do
          expect(image.alt).to eq(image.title)
        end
      end
      context 'when an alt attribute is given' do
        it 'returns that alt attribute' do
          expect(image_with_alt_text.alt).to  eq('Alt Text')
        end
      end
    end

    describe ".per_page" do
      context "dialog is true" do
        context "has_size_options is true" do
          it "returns image count specified by Images.pages_per_dialog_that_have_size_options option" do
            expect(::Refinery::Image.per_page(true, true)).to eq(Images.pages_per_dialog_that_have_size_options)
          end
        end

        context "has_size_options is false" do
          it "returns image count specified by Images.pages_per_dialog option" do
            expect(::Refinery::Image.per_page(true)).to eq(Images.pages_per_dialog)
          end
        end
      end

      context "dialog is false" do
        it "returns image count specified by Images.pages_per_admin_index option" do
          expect(::Refinery::Image.per_page).to eq(Images.pages_per_admin_index)
        end
      end
    end

    describe ".user_image_sizes" do
      it "returns a hash" do
        expect(Refinery::Images.user_image_sizes).to be_a_kind_of(Hash)
      end
    end

    # The sample image has dimensions 500x375
    describe '#thumbnail_dimensions returns correctly with' do
      it 'nil' do
        expect(created_image.thumbnail_dimensions(nil)).to eq({ :width => 500, :height => 375 })
      end

      it '200x200#ne' do
        expect(created_image.thumbnail_dimensions('200x200#ne')).to eq({ :width => 200, :height => 200 })
      end

      it '100x150#c' do
        expect(created_image.thumbnail_dimensions('100x150#c')).to eq({ :width => 100, :height => 150 })
      end

      it '250x250>' do
        expect(created_image.thumbnail_dimensions('250x250>')).to eq({ :width => 250, :height => 188 })
      end

      it '600x375>' do
        expect(created_image.thumbnail_dimensions('600x375>')).to eq({ :width => 500, :height => 375 })
      end

      it '100x475>' do
        expect(created_image.thumbnail_dimensions('100x475>')).to eq({ :width => 100, :height => 75 })
      end

      it '100x150' do
        expect(created_image.thumbnail_dimensions('100x150')).to eq({ :width => 100, :height => 75 })
      end

      it '200x150' do
        expect(created_image.thumbnail_dimensions('200x150')).to eq({ :width => 200, :height => 150 })
      end

      it '300x150' do
        expect(created_image.thumbnail_dimensions('300x150')).to eq({ :width => 200, :height => 150 })
      end

      it '5x5' do
        expect(created_image.thumbnail_dimensions('5x5')).to eq({ :width => 5, :height => 4 })
      end
    end

    describe '#thumbnail_dimensions returns correctly with' do
      let(:created_alternate_image) { FactoryGirl.create(:alternate_image) }

      it 'nil' do
        expect(created_alternate_image.thumbnail_dimensions(nil)).to eq({ :width => 376, :height => 184 })
      end

      it '225x255>' do
        expect(created_alternate_image.thumbnail_dimensions('225x255>')).to eq({ :width => 225, :height => 110 })
      end
    end

    describe '#thumbnail_dimensions returns correctly with user-defined geometries' do
      it ':medium' do
        expect(created_image.thumbnail_dimensions(:medium)).to eq({ :width => 225, :height => 169 })
      end

      it ':large' do
        expect(created_image.thumbnail_dimensions(:large)).to eq({ :width => 450, :height => 338 })
      end
    end

  end
end
