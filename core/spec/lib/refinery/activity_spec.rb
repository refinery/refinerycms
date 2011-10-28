require "spec_helper"

describe Refinery::Activity do
  before do
    module Y
      module Y
        class Z
        end
      end
    end
    @activity = Refinery::Activity.new(:class_name => "Y::Y::Z")
  end

  describe "#base_class_name" do
    it "should return the base class name, less module nesting" do
      @activity.base_class_name.should == "Z"
    end
  end

  describe "#klass" do
    it "returns class constant" do
      @activity.klass.should == Y::Y::Z
    end
  end

  describe "#url_prefix" do
    it "returns edit_ by default" do
      @activity.url_prefix.should == "edit_"
    end

    it "returns user specified prefix" do
      @activity.url_prefix = "testy"
      @activity.url_prefix.should == "testy_"
      @activity.url_prefix = "testy_"
      @activity.url_prefix.should == "testy_"
    end
  end

  describe "#url" do
    it "should return the url" do
      @activity.url.should == "edit_refinery_admin_z_path"
    end
  end
end
