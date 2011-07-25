require 'spec_helper'

describe Image do
  let(:image) do
    Image.create!(:id => 1,
                  :image => File.new(File.expand_path('../../uploads/beach.jpeg', __FILE__)))
  end

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
      name, geometry = Image.user_image_sizes.first
      image.thumbnail(name).url.should == image.thumbnail(geometry).url
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
        it "returns image count specified by PAGES_PER_DIALOG_THAT_HAS_SIZE_OPTIONS constant" do
          Image.per_page(true, true).should == Image::PAGES_PER_DIALOG_THAT_HAS_SIZE_OPTIONS
        end
      end

      context "has_size_options is false" do
        it "returns image count specified by PAGES_PER_DIALOG constant" do
          Image.per_page(true).should == Image::PAGES_PER_DIALOG
        end
      end
    end

    context "dialog is false" do
      it "returns image count specified by PAGES_PER_ADMIN_INDEX constant" do
        Image.per_page.should == Image::PAGES_PER_ADMIN_INDEX
      end
    end
  end

  describe ".user_image_sizes" do
    it "sets and returns a hash consisting of the keys contained in the RefinerySetting" do
      Image.user_image_sizes.should == RefinerySetting.get(:user_image_sizes)
    end
  end

  describe '#thumbnail_dimensions' do
    it 'returns its own dimensions with nil geometry' do
      dimensions = image.thumbnail_dimensions(nil)
      dimensions[:width].should == 500
      dimensions[:height].should == 375
    end

    it 'returns the correct dimensions for crop' do
      dimensions = image.thumbnail_dimensions('200x200#ne')
      dimensions[:width].should == 200
      dimensions[:height].should == 200

      dimensions = image.thumbnail_dimensions('100x150#c')
      dimensions[:width].should == 100
      dimensions[:height].should == 150
    end

    it 'returns the correct dimensions for resize' do
      dimensions = image.thumbnail_dimensions('250x250>')
      dimensions[:width].should == 250
      dimensions[:height].should == 188

      dimensions = image.thumbnail_dimensions('600x375>')
      dimensions[:width].should == 500
      dimensions[:height].should == 375

      dimensions = image.thumbnail_dimensions('200x150')
      dimensions[:width].should == 126
      dimensions[:height].should == 150
    end
  end

end
