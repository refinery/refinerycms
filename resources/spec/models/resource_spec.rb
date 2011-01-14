require 'spec_helper'

describe Resource do

  def reset_resource(options = {})
    @valid_attributes = {
      :id => 1,
      :file => File.new(File.expand_path('../../uploads/refinery_is_awesome.txt', __FILE__))
    }.merge(options)

    @resource.destroy if @resource
    @resource = Resource.create!(@valid_attributes)
  end

  def resource_can_be_destroyed
    @resource.destroy.should == true
  end

  before(:each) do
    reset_resource
  end

  context "with valid attributes" do
    it "should create successfully" do
      @resource.errors.empty?
    end
  end

  context "resource url" do
    it "should respond to .url" do
      @resource.respond_to?(:url).should == true
    end

    it "should not support thumbnailing like images do" do
      @resource.respond_to?(:thumbnail).should == false
    end

    it "should contain its filename at the end" do
      @resource.url.split('/').last.should == @resource.file_name
    end
  end

  describe ".create_resources" do
    let(:file) { File.new(File.expand_path('../../uploads/refinery_is_awesome.txt', __FILE__)) }

    context "when only one resource uploaded" do
      it "returns an array containing one resource" do
        Resource.create_resources(:file => file).should have(1).item
      end
    end

    context "when many resources uploaded at once" do
      it "returns an array containing all those resources" do
        Resource.create_resources(:file => [file, file, file]).should have(3).items
      end
    end
  end

end
