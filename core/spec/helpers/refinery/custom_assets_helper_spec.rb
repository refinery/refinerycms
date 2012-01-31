require "spec_helper"

module Refinery
  describe CustomAssetsHelper do
    describe "custom_javascripts" do
      before(:each) do
        Refinery::Core.clear_javascripts!
      end

      it "should return one custom javascript in array when one javascript is registred" do
        Refinery::Core.register_javascript("test")
        helper.custom_javascripts.should eq ["test"]
      end

      it "should return two custom javascripts in array when two javascripts are registred" do
        Refinery::Core.register_javascript("test")
        Refinery::Core.register_javascript("parndt")
        helper.custom_javascripts.should eq ["test", "parndt"]
      end

      it "should return empty array when no javascript is registred" do
        helper.custom_javascripts.should eq []
      end
    end

    describe "custom_stylesheets" do
      before(:each) do
        Refinery::Core.clear_stylesheets!
      end

      it "should return one custom stylesheet class in array when one stylesheet is registred" do
        Refinery::Core.register_stylesheet("test")
        helper.custom_stylesheets.first.path.should eq "test"
      end

      it "should return two custom stylesheet classes in array when two stylesheets are registred" do
        Refinery::Core.register_stylesheet("test")
        Refinery::Core.register_stylesheet("parndt")
        helper.custom_stylesheets.collect(&:path).should eq ["test", "parndt"]
      end

      it "should return empty array when no stylesheet is registred" do
        helper.custom_stylesheets.should eq []
      end

      it "should return stylesheet class with path and options when both are specified" do
        Refinery::Core.register_stylesheet("test", :media => 'screen')
        helper.custom_stylesheets.first.path.should eq("test")
        helper.custom_stylesheets.first.options.should eq({:media => 'screen'})
      end
    end
  end
end
