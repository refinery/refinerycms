require "spec_helper"

describe Refinery::Activity do
  before do
    module Y
      module Y
        class Z
        end
      end
    end
    @activity = Refinery::Activity.new(:class_name => "Y::Y::Z", :url_prefix => "rush")
  end

  describe "#base_class_name" do
    it "should return the base class name, less module nesting" do
      @activity.base_class_name.should == "Z"
    end
  end

  describe "#url" do
    it "should return the url" do
      @activity.url.should == "rush_refinery_admin_z_path"
    end
  end
end
