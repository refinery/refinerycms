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
      @resource.url.should =~ %r{#{@resource.file_uid.split('/').last}$}
    end
  end


end
