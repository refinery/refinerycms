require "spec_helper"

describe Refinery::Activity do
  before { module X; module Y; class Z; end; end; end }

  let(:activity) { Refinery::Activity.new(:class_name => "X::Y::Z") }

  describe "#base_class_name" do
    it "should return the base class name, less module nesting" do
      activity.base_class_name.should == "Z"
    end
  end

  describe "#klass" do
    it "returns class constant" do
      activity.klass.should == X::Y::Z
    end
  end

  describe "#url_prefix" do
    it "returns edit_ by default" do
      activity.url_prefix.should == "edit_"
    end

    it "returns user specified prefix" do
      activity.url_prefix = "testy"
      activity.url_prefix.should == "testy_"
      activity.url_prefix = "testy_"
      activity.url_prefix.should == "testy_"
    end
  end

  describe "#url" do
    it "should return the url" do
      # we're stubbing here because X::Y::Z is just namespaced dummy class
      # which isn't inheriting from AR::Base and it doesn't have any routes
      # associated with it
      X::Y::Z.stub_chain(:model_name, :param_key).and_return("y_z")

      activity.url.should == "edit_refinery_admin_y_z_path"
    end
  end
end
