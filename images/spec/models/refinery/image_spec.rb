require 'spec_helper'

module Refinery
  describe Image do

    let(:image) { FactoryGirl.build(:image) }
    let(:created_image) { FactoryGirl.create(:image) }

    describe "validations" do
      describe "valid #image" do
        before do
          @file = Refinery.roots(:'refinery/images').join("spec/fixtures/beach.jpeg")
          Images.stub(:max_image_size).and_return(File.read(@file).size + 10.megabytes)
        end

        it "should be valid when size does not exceed .max_image_size" do
          Image.new(:image => @file).should be_valid
        end
      end

      describe "too large #image" do
        before do
          @file = Refinery.roots(:'refinery/images').join("spec/fixtures/beach.jpeg")
          Images.stub(:max_image_size).and_return(0)
          @image = Image.new(:image => @file)
        end

        it "should not be valid when size exceeds .max_image_size" do
          @image.should_not be_valid
        end

        it "should contain an error message" do
          @image.valid?
          @image.errors.should_not be_empty
          @image.errors[:image].should == ["Image should be smaller than #{Images.max_image_size} bytes in size"]
        end
      end

      describe "invalid argument for #image" do
        before do
          @image = Image.new
        end

        it "has an error message" do
          @image.valid?
          @image.errors.should_not be_empty
          @image.errors[:image].should == ["You must specify an image for upload"]
        end
      end

      context "when image exists" do
        it "doesn't allow to replace it with image which has different file name" do
          created_image.image = Refinery.roots(:'refinery/images').join("spec/fixtures/beach-alternate.jpeg")
          created_image.should_not be_valid
          created_image.should have_at_least(1).error_on(:image_name)
        end

        it "allows to replace it with image which has the same file name" do
          created_image.image = Refinery.roots(:'refinery/images').join("spec/fixtures/beach.jpeg")
          created_image.should be_valid
        end
      end
    end

    context "image url" do
      it "responds to .thumbnail" do
        image.should respond_to(:thumbnail)
      end

      it "contains its filename at the end" do
        created_image.url.split('/').last.should == created_image.image_name
      end

      it "becomes different when supplying geometry" do
        created_image.url.should_not == created_image.thumbnail('200x200').url
      end

      it "has different urls for each geometry string" do
        created_image.thumbnail('200x200').url.should_not == created_image.thumbnail('200x201').url
      end

      it "uses right geometry when given a thumbnail name" do
        name, geometry = Refinery::Images.user_image_sizes.first
        created_image.thumbnail(name).url.should == created_image.thumbnail(geometry).url
      end
    end

    describe "#title" do
      it "returns a titleized version of the filename" do
        image.title.should == "Beach"
      end
    end

    describe ".per_page" do
      context "dialog is true" do
        context "has_size_options is true" do
          it "returns image count specified by Images.pages_per_dialog_that_have_size_options option" do
            ::Refinery::Image.per_page(true, true).should == Images.pages_per_dialog_that_have_size_options
          end
        end

        context "has_size_options is false" do
          it "returns image count specified by Images.pages_per_dialog option" do
            ::Refinery::Image.per_page(true).should == Images.pages_per_dialog
          end
        end
      end

      context "dialog is false" do
        it "returns image count specified by Images.pages_per_admin_index option" do
          ::Refinery::Image.per_page.should == Images.pages_per_admin_index
        end
      end
    end

    describe ".user_image_sizes" do
      it "returns a hash" do
        Refinery::Images.user_image_sizes.should be_a_kind_of(Hash)
      end
    end

    # The sample image has dimensions 500x375
    describe '#thumbnail_dimensions returns correctly with' do
      it 'nil' do
        created_image.thumbnail_dimensions(nil).should == { :width => 500, :height => 375 }
      end

      it '200x200#ne' do
        created_image.thumbnail_dimensions('200x200#ne').should == { :width => 200, :height => 200 }
      end

      it '100x150#c' do
        created_image.thumbnail_dimensions('100x150#c').should == { :width => 100, :height => 150 }
      end

      it '250x250>' do
        created_image.thumbnail_dimensions('250x250>').should == { :width => 250, :height => 188 }
      end

      it '600x375>' do
        created_image.thumbnail_dimensions('600x375>').should == { :width => 500, :height => 375 }
      end

      it '100x475>' do
        created_image.thumbnail_dimensions('100x475>').should == { :width => 100, :height => 75 }
      end

      it '100x150' do
        created_image.thumbnail_dimensions('100x150').should == { :width => 100, :height => 75 }
      end

      it '200x150' do
        created_image.thumbnail_dimensions('200x150').should == { :width => 200, :height => 150 }
      end

      it '300x150' do
        created_image.thumbnail_dimensions('300x150').should == { :width => 200, :height => 150 }
      end

      it '5x5' do
        created_image.thumbnail_dimensions('5x5').should == { :width => 5, :height => 4 }
      end
    end

    describe '#thumbnail_dimensions returns correctly with' do
      let(:created_alternate_image) { FactoryGirl.create(:alternate_image) }

      it 'nil' do
        created_alternate_image.thumbnail_dimensions(nil).should == { :width => 376, :height => 184 }
      end

      it '225x255>' do
        created_alternate_image.thumbnail_dimensions('225x255>').should == { :width => 225, :height => 110 }
      end
    end

  end
end
