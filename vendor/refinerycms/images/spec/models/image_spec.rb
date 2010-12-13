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
      @image.thumbnail(nil).url.should =~ %r{#{@image.image_uid.split('/').last}$}
    end

    it "should be different when supplying geometry" do
      @image.thumbnail(nil).url.should_not == @image.thumbnail('200x200').url
    end

    it "should have different urls for each geometry string" do
      @image.thumbnail('200x200').url.should_not == @image.thumbnail('200x201').url
    end

  end


end
