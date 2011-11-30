require 'spec_helper'

module Refinery
  describe Image do

    let(:image) { FactoryGirl.create(:image) }

    context "with valid attributes" do
      it "should create successfully" do
        image.errors.should be_empty
      end
    end

    context "image url" do
      it "should respond to .thumbnail" do
        image.should respond_to(:thumbnail)
      end

      it "should contain its filename at the end" do
        image.thumbnail(nil).url.split('/').last.should == image.image_name
      end

      it "should be different when supplying geometry" do
        image.thumbnail(nil).url.should_not == image.thumbnail('200x200').url
      end

      it "should have different urls for each geometry string" do
        image.thumbnail('200x200').url.should_not == image.thumbnail('200x201').url
      end

      it "should use right geometry when given a thumbnail name" do
        ::Refinery::Setting.find_or_set(:user_image_sizes, {
          :small => '110x110>',
          :medium => '225x255>',
          :large => '450x450>'
        }, :destroyable => false)
        name, geometry = ::Refinery::Image.user_image_sizes.first
        image.thumbnail(name).url.should == image.thumbnail(geometry).url
      end
    end

    describe "#title" do
      context "with alt text" do
        before do
          image.alt = "Alt text"
        end

        it "returns the alt text" do
          image.title.should == "Alt text"
        end
      end

      context "with no alt text" do
        before do
          image.alt = ""
        end

        it "returns a titleized version of the filename" do
          image.title.should == "Beach"
        end
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
      it "sets and returns a hash consisting of the keys contained in the ::Refinery::Setting" do
        ::Refinery::Image.user_image_sizes.should == ::Refinery::Setting.get(:user_image_sizes)
      end
    end

    # The sample image has dimensions 500x375
    describe '#thumbnail_dimensions returns correctly with' do
      it 'nil' do
        image.thumbnail_dimensions(nil).should == { :width => 500, :height => 375 }
      end

      it '200x200#ne' do
        image.thumbnail_dimensions('200x200#ne').should == { :width => 200, :height => 200 }
      end

      it '100x150#c' do
        image.thumbnail_dimensions('100x150#c').should == { :width => 100, :height => 150 }
      end

      it '250x250>' do
        image.thumbnail_dimensions('250x250>').should == { :width => 250, :height => 188 }
      end

      it '600x375>' do
        image.thumbnail_dimensions('600x375>').should == { :width => 500, :height => 375 }
      end

      it '100x475>' do
        image.thumbnail_dimensions('100x475>').should == { :width => 100, :height => 75 }
      end

      it '100x150' do
        image.thumbnail_dimensions('100x150').should == { :width => 100, :height => 75 }
      end

      it '200x150' do
        image.thumbnail_dimensions('200x150').should == { :width => 200, :height => 150 }
      end

      it '300x150' do
        image.thumbnail_dimensions('300x150').should == { :width => 200, :height => 150 }
      end

      it '5x5' do
        image.thumbnail_dimensions('5x5').should == { :width => 5, :height => 4 }
      end
    end

    describe "validations" do
      describe "valid #image" do
        before(:each) do
          @file = Refinery.roots(:'refinery/images').join("spec/fixtures/beach.jpeg")
          Images.max_image_size = (File.read(@file).size + 10.megabytes)
        end

        it "should be valid when size does not exceed .max_image_size" do
          Image.new(:image => @file).should be_valid
        end
      end

      describe "too large #image" do
        before(:each) do
          @file = Refinery.roots(:'refinery/images').join("spec/fixtures/beach.jpeg")
          Images.max_image_size = 0
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
        before(:each) do
          @image = Image.new
        end

        it "does not raise an exception" do
          expect {
            @image.valid?
          }.should_not raise_error(NoMethodError)
        end

        it "has an error message" do
          @image.valid?
          @image.errors.should_not be_empty
          @image.errors[:image].should == ["You must specify an image for upload"]
        end
      end
    end
  end
end
