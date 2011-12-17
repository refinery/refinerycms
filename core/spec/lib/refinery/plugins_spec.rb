require 'spec_helper'

module Refinery
  module MyPlugin
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "my_plugin"
        plugin.hide_from_menu = true
      end
    end
  end

  module MyOtherPlugin
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "my_other_plugin"
        plugin.hide_from_menu = true
      end
    end
  end

  ::I18n.backend.store_translations :en, :refinery => {
    :plugins => {
      :my_plugin => {
        :title => "my plugin"
      },
      :my_other_plugin => {
        :title => "my other plugin"
      }
    }
  }

  describe Plugins do

    before(:each) do
      # First, deactivate all.
      subject.class.set_active([])
    end

    describe '#activate' do
      it "activates a plugin" do
        subject.class.activate("my_plugin")

        subject.class.active.names.should include("my_plugin")
      end

      it "only activates the same plugin once" do
         subject.class.activate("my_other_plugin")
         subject.class.activate("my_other_plugin")

         subject.class.active.names.count("my_other_plugin").should == 1
      end

      it "doesn't deactivate the first plugin when another is activated" do
        subject.class.activate("my_plugin")
        subject.class.activate("my_other_plugin")

        subject.class.active.names.should include("my_plugin")
        subject.class.active.names.should include("my_other_plugin")
      end
    end

    describe '#deactivate' do
      it "deactivates a plugin" do
        subject.class.activate("my_plugin")
        subject.class.deactivate("my_plugin")

        subject.class.active.count.should == 0
      end
    end

    describe '#set_active' do

      it "activates a single plugin" do
        subject.class.set_active(%w(my_plugin))

        subject.class.active.names.should include("my_plugin")
      end

      it "activates a list of plugins" do
        subject.class.set_active(%w(my_plugin my_other_plugin))

        subject.class.active.names.should include("my_plugin")
        subject.class.active.names.should include("my_plugin")

        subject.class.active.count.should == 2
      end

      it "deactivates the initial plugins when another set is set_active" do
        subject.class.set_active(%w(my_plugin))
        subject.class.set_active(%w(my_other_plugin))

        subject.class.active.names.should_not include("my_plugin")
        subject.class.active.names.should include("my_other_plugin")
        subject.class.active.count.should == 1
      end

    end

    describe '#registered' do
      it 'identifies as Refinery::Plugins' do
        subject.class.registered.class.should == subject.class
      end
    end

    describe '#active' do
      it 'identifies as Refinery::Plugins' do
        subject.class.active.class.should == subject.class
      end

      it 'only contains items that are registered' do
        subject.class.set_active(%w(my_plugin))
        subject.class.active.any?.should be_true
        subject.class.active.all?{|p| subject.class.registered.include?(p)}.should be_true
      end
    end

    describe '#always_allowed' do
      it 'should identify as Refinery::Plugins' do
        subject.class.always_allowed.class.should == subject.class
      end

      it 'only contains items that are always allowed' do
        subject.class.always_allowed.any?.should be_true
        subject.class.always_allowed.all? { |p| p.always_allow_access }.should be_true
      end
    end

    describe '#in_menu' do
      it 'identifies as Refinery::Plugins' do
        subject.class.registered.in_menu.class.should == subject.class
      end

      it 'only contains items that are in the menu' do
        subject.class.registered.in_menu.any?.should be_true
        subject.class.registered.in_menu.all? { |p| !p.hide_from_menu }.should be_true
      end
    end

    describe ".find_by_name" do
      it "finds plugin by given name" do
        subject.class.set_active(%w(my_plugin))
        subject.class.active.find_by_name("my_plugin").name.should == "my_plugin"
      end
    end

    describe ".find_by_title" do
      it "finds plugin by given title" do
        subject.class.set_active(%w(my_plugin))
        subject.class.active.find_by_title("my plugin").title.should == "my plugin"
      end
    end

  end
end
