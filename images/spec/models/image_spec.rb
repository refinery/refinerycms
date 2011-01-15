require 'spec_helper'

describe Image do

  def reset_image(options = {})
    @valid_attributes = {
      :id => 1,
      :image => File.new(File.expand_path('../../uploads/beach.jpeg', __FILE__))
    }.merge(options)

    @image.destroy if @image
    @image = Image.create!(@valid_attributes)
  end

  def image_can_be_destroyed
    @image.destroy.should == true
  end

  before(:each) do
    reset_image
  end

  context "with valid attributes" do
    it "should create successfully" do
      @image.errors.empty?
    end
  end

  context "image url" do
    it "should respond to .thumbnail" do
      @image.respond_to?(:thumbnail).should == true
    end

    it "should contain its filename at the end" do
      @image.thumbnail(nil).url.split('/').last.should == @image.image_name
    end

    it "should be different when supplying geometry" do
      @image.thumbnail(nil).url.should_not == @image.thumbnail('200x200').url
    end

    it "should have different urls for each geometry string" do
      @image.thumbnail('200x200').url.should_not == @image.thumbnail('200x201').url
    end

    it "should use right geometry when given a thumbnail name" do
      name, geometry = Image.user_image_sizes.first
      @image.thumbnail(name).url.should == @image.thumbnail(geometry).url
    end

  end

  describe "#title" do
    it "returns a titleized version of the filename" do
      @image.title.should == "Beach"
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
    it "sets and returns a hash consisiting of 3 image sizes" do
      Image.user_image_sizes.keys.should == [:small, :medium, :large]
    end
  end

end
