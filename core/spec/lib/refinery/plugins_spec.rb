require 'spec_helper'

module Refinery
  module MyPlugin
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "my_plugin"
      end
    end
  end

  module MyOtherPlugin
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "my_other_plugin"
      end
    end
  end
end

module Refinery
  describe Plugins do

    before(:each) do
      # First, deactivate all.
      Plugins.set_active([])
    end

    describe "self.activate" do
      it "should activate a plugin" do
        Plugins.activate("my_plugin")

        Plugins.active.names.should include("my_plugin")
      end

      it "should only active the same plugin once" do
         Plugins.activate("my_other_plugin")
         Plugins.activate("my_other_plugin")

         Plugins.active.names.count("my_other_plugin").should == 1
      end

      it "should not deactivate the first plugin when another is activated" do
        Plugins.activate("my_plugin")
        Plugins.activate("my_other_plugin")

        Plugins.active.names.should include("my_plugin")
        Plugins.active.names.should include("my_other_plugin")
      end
    end

    describe "self.deactivate" do
      it "should deactivate a plugin" do
        Plugins.activate("my_plugin")
        Plugins.deactivate("my_plugin")

        Plugins.active.count.should == 0
      end
    end

    describe "self.set_active" do

      it "should activate a single plugin" do
        Plugins.set_active(%w(my_plugin))

        Plugins.active.names.should include("my_plugin")
      end

      it "should activate a list of plugins" do
        Plugins.set_active(%w(my_plugin my_other_plugin))

        Plugins.active.names.should include("my_plugin")
        Plugins.active.names.should include("my_plugin")

        Plugins.active.count.should == 2
      end

      it "should deactivate the initial plugins when another set is set_active" do
        Plugins.set_active(%w(my_plugin))
        Plugins.set_active(%w(my_other_plugin))

        Plugins.active.names.should_not include("my_plugin")
        Plugins.active.names.should include("my_other_plugin")
        Plugins.active.count.should == 1
      end

    end

  end
end
