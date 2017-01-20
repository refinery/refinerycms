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

  module MyOrderedPlugin
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "my_ordered_plugin"
      end
    end
  end

  module MyOtherOrderedPlugin
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "my_other_ordered_plugin"
      end
    end
  end

  module MyUnorderedPlugin
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      ::Refinery::Plugin.register do |plugin|
        plugin.name = "my_unordered_plugin"
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
      },
      :my_ordered_plugin => {
        :title => "my ordered plugin"
      },
      :my_other_ordered_plugin => {
        :title => "my other ordered plugin"
      },
      :my_unodered_plugin => {
        :title => "my unordered plugin"
      }
    }
  }

  RSpec.describe Plugins do
    def mock_plugin(name)
      ::Refinery::Plugin.new.tap do |plugin|
        plugin.name = name
      end
    end

    describe '#registered' do
      it 'identifies as Refinery::Plugins' do
        expect(described_class.registered.class).to eq(described_class)
      end
    end

    describe '#always_allowed' do
      it 'should identify as Refinery::Plugins' do
        expect(described_class.always_allowed.class).to eq(described_class)
      end

      it 'only contains items that are always allowed' do
        expect(described_class.always_allowed.any?).to be_truthy
        expect(described_class.always_allowed.all?(&:always_allow_access)).to be_truthy
      end
    end

    describe '#in_menu' do
      it 'identifies as Refinery::Plugins' do
        expect(described_class.registered.in_menu.class).to eq(described_class)
      end

      it 'only contains items that are in the menu' do
        expect(described_class.registered.in_menu.any?).to be_truthy
        expect(described_class.registered.in_menu.all? { |p| !p.hide_from_menu }).to be_truthy
      end

      it "orders by plugin_priority config" do
        allow(described_class).to receive(:registered).and_return(
          described_class.new([
            mock_plugin("one"),
            mock_plugin("two"),
            mock_plugin("three"),
            mock_plugin("four"),
            mock_plugin("five")
          ])
        )

        expect {
          Core.config.plugin_priority = %w(three five two four)
        }.to change { described_class.registered.in_menu.names }.from(
          %w(one two three four five)
        ).to(
          %w(three five two four one)
        )
      end

      it "orders by plugin_priority config" do
        Core.config.plugin_priority = %w(my_ordered_plugin my_plugin my_other_ordered_plugin)
        expect(subject.registered.in_menu.names.take(2)).to eq %w(my_ordered_plugin my_other_ordered_plugin)
      end
    end

    describe ".find_by_name" do
      it "finds plugin by given name" do
        expect(described_class.registered.find_by_name("my_plugin").name).to eq("my_plugin")
      end
    end

    describe ".find_by_title" do
      it "finds plugin by given title" do
        expect(described_class.registered.find_by_title("my plugin").title).to eq("my plugin")
      end
    end

    describe ".first_in_menu_with_url" do
      it "finds plugins that are landable" do
        first_in_menu_with_url = described_class.registered.in_menu.detect do |plugin|
          plugin.url.present?
        end

        expect(described_class.registered.first_in_menu_with_url.title).to eq(first_in_menu_with_url.title)
      end
    end

  end
end
