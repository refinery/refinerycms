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

  RSpec.describe Plugins do
    subject { Refinery::Plugins }

    describe '#registered' do
      it 'identifies as Refinery::Plugins' do
        expect(subject.registered.class).to eq(subject)
      end
    end

    describe '#always_allowed' do
      it 'should identify as Refinery::Plugins' do
        expect(subject.always_allowed.class).to eq(subject)
      end

      it 'only contains items that are always allowed' do
        expect(subject.always_allowed.any?).to be_truthy
        expect(subject.always_allowed.all?(&:always_allow_access)).to be_truthy
      end
    end

    describe '#in_menu' do
      it 'identifies as Refinery::Plugins' do
        expect(subject.registered.in_menu.class).to eq(subject)
      end

      it 'only contains items that are in the menu' do
        expect(subject.registered.in_menu.any?).to be_truthy
        expect(subject.registered.in_menu.all? { |p| !p.hide_from_menu }).to be_truthy
      end
    end

    describe ".find_by_name" do
      it "finds plugin by given name" do
        expect(subject.registered.find_by_name("my_plugin").name).to eq("my_plugin")
      end
    end

    describe ".find_by_title" do
      it "finds plugin by given title" do
        expect(subject.registered.find_by_title("my plugin").title).to eq("my plugin")
      end
    end

    describe ".first_in_menu_with_url" do
      it "finds plugins that are landable" do
        skip
      end
    end

  end
end
