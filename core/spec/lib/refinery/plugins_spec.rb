require 'spec_helper'

module Refinery
  module MyPlugin
    class Engine < Rails::Engine
      Refinery::Plugin.register do |plugin|
        plugin.name = "my_plugin"
      end
    end
  end

  module MyOtherPlugin
    class Engine < Rails::Engine
      Refinery::Plugin.register do |plugin|
        plugin.name = "my_other_plugin"
      end
    end
  end
end

module Refinery
  describe Plugins do

    describe "self.set_active" do

      it "should activate a plugin" do
        Plugins.set_active(["my_plugin"])
        Plugins.active.names.should include("my_plugin")
      end

      it "should only active the same plugin once" do
         Plugins.set_active(["my_plugin"])
         Plugins.set_active(["my_plugin"])
         Plugins.active.names.count("my_plugin").should == 1
      end

      it "should not deactivate the first plugin when another is activated" do
        Plugins.set_active(["my_plugin"])
        Plugins.set_active(["my_other_plugin"])
        Plugins.active.names.should include("my_plugin")
      end

    end

  end
end
