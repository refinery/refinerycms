require "spec_helper"

module Refinery
  module RefineryRspec
    class Engine < ::Rails::Engine
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "refinery_rspec"
      end
    end
  end
end

module Refinery
  describe Plugin do
    
    let(:plugin) { Refinery::Plugins.registered.detect { |plugin| plugin.name == "refinery_rspec" } }

    describe ".register" do
      it "must have a name" do
        lambda { Plugin.register {} }.should raise_error
      end
    end

    describe "#class_name" do
      it "returns class name" do
        plugin.class_name.should == "RefineryRspec"
      end
    end

    describe "#always_allow_access?" do
      it "returns false if @always_allow_access is not set or its set to false" do
        plugin.always_allow_access?.should be_false
      end

      it "returns true if set so" do
        plugin.stub(:always_allow_access?).and_return(true)
        plugin.always_allow_access?.should be
      end
    end

    describe "#dashboard?" do
      it "returns false if @dashboard is not set or its set to false" do
        plugin.dashboard.should be_false
      end

      it "returns true if set so" do
        plugin.stub(:dashboard).and_return(true)
        plugin.dashboard.should be
      end
    end

    describe "#menu_match" do
      it "returns regexp based on plugin name" do
        plugin.menu_match.should == /(admin|refinery)\/refinery_rspec$/
      end
    end

    describe "#highlighted?" do
      it "returns true if params[:controller] match menu_match regexp" do
        plugin.highlighted?({:controller => "refinery/refinery_rspec"}).should be
      end

      it "returns true if dashboard? is true and params[:action] == error_404" do
        plugin.stub(:dashboard?).and_return(true)
        plugin.highlighted?({:action => "error_404"}).should be
      end
    end

  end
end
