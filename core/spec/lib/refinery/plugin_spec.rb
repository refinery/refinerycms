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

    describe "#title" do
      it "returns plugin title defined by I18n" do
        ::I18n.load_path += Dir[File.dirname(__FILE__) + "/../../locales/*.yml"]
        plugin.title.should == "RefineryCMS RSpec"
      end
    end

    describe "#description" do
      it "returns plugin description defined by I18n" do
        ::I18n.load_path += Dir[File.dirname(__FILE__) + "/../../locales/*.yml"]
        plugin.description.should == "RSpec tests for plugin.rb"
      end
    end

    describe "#activity" do

    end

    describe "#activity=" do

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

    describe "#url" do
      before do
        plugin.stub(:url) do |arg|
          if arg == :controller
            {:controller => "/admin/testb"}
          elsif arg == :directory
            {:controller => "/admin/testc"}
          else
            {:controller => "/admin/refinery_rspec"}
          end
        end
      end

      context "when @url is already defined" do
        it "returns hash" do
          plugin.stub(:url).and_return({:controller => "/admin/testa"})
          plugin.url.should == {:controller => "/admin/testa"}
        end
      end

      context "when controller is present" do
        it "returns hash based on it" do
          plugin.url(:controller).should == {:controller => "/admin/testb"}
        end
      end

      context "when directory is present" do
        it "returns hash based on it" do
          plugin.url(:directory).should == {:controller => "/admin/testc"}
        end
      end

      context "when controller and directory not present" do
        it "returns hash based on plugins name" do
          plugin.url.should == {:controller => "/admin/refinery_rspec"}
        end
      end
    end

  end
end
