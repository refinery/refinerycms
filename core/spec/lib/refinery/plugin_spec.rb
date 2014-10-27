require 'spec_helper'

module Refinery
  module RefineryRspec
    class Engine < ::Rails::Engine
      isolate_namespace ::Refinery
      ::Refinery::Plugin.register do |plugin|
        plugin.name = 'refinery_rspec'
        plugin.hide_from_menu = true
      end
    end
  end
end

module Refinery
  describe Plugin do

    let(:plugin) { ::Refinery::Plugins.registered.detect { |plugin| plugin.name == 'refinery_rspec' } }

    before do
      ::I18n.backend.store_translations :en, :refinery => {
        :plugins => {
          :refinery_rspec => {
            :title => "Refinery CMS RSpec",
            :description => "RSpec tests for plugin.rb"
          }
        }
      }
    end

    describe '.register' do
      it 'must have a name' do
        expect { Plugin.register {} }.to raise_error
      end
    end

    describe '#class_name' do
      it 'returns class name' do
        expect(plugin.class_name).to eq('RefineryRspec')
      end
    end

    describe '#title' do
      it 'returns plugin title defined by I18n' do
        expect(plugin.title).to eq('Refinery CMS RSpec')
      end
    end

    describe '#description' do
      it 'returns plugin description defined by I18n' do
        expect(plugin.description).to eq('RSpec tests for plugin.rb')
      end
    end

    describe '#pathname' do
      it 'should be set by default' do
        expect(plugin.pathname).not_to eq(nil)
      end
    end

    describe '#pathname=' do
      it 'converts string input to pathname' do
        plugin.pathname = Rails.root.to_s
        expect(plugin.pathname).to eq(Rails.root)
      end

      it 'overrides the default pathname' do
        current_pathname = plugin.pathname
        new_pathname = current_pathname.join('tmp', 'path')

        expect(current_pathname).not_to eq(new_pathname)

        plugin.pathname = new_pathname
        expect(plugin.pathname).to eq(new_pathname)
      end
    end

    describe '#always_allow_access' do
      it 'returns false if @always_allow_access is not set or its set to false' do
        expect(plugin.always_allow_access).to be_falsey
      end

      it 'returns true if set so' do
        allow(plugin).to receive(:always_allow_access).and_return(true)
        expect(plugin.always_allow_access).to be
      end
    end

    describe '#menu_match' do
      it 'returns regexp based on plugin name' do
        expect(plugin.menu_match).to eq(%r{refinery/refinery_rspec(/.+?)?$})
      end
    end

    describe '#highlighted?' do
      it 'returns true if params[:controller] match menu_match regexp' do
        expect(plugin.highlighted?({:controller => '/refinery/admin/refinery_rspec'})).to be
        expect(plugin.highlighted?({:controller => '/refinery/refinery_rspec'})).to be
      end
    end

    describe '#url' do
      class Plugin
        def reset_url!
          @url = nil
        end
      end

      before { plugin.reset_url! }

      context 'when @url is already defined' do
        it 'returns hash' do
          allow(plugin).to receive(:url).and_return({:controller => 'refinery/admin/testa'})
          expect(plugin.url[:controller]).to eq('refinery/admin/testa')
        end
      end

      context 'when controller is present' do
        it 'returns hash based on it' do
          allow(plugin).to receive(:controller).and_return('testb')
          expect(plugin.url[:controller]).to eq('refinery/admin/testb')
        end
      end

      context 'when directory is present' do

        it 'returns hash based on it' do
          allow(plugin).to receive(:directory).and_return('first/second/testc')
          expect(plugin.url[:controller]).to eq('refinery/admin/testc')
        end
      end

      context 'when controller and directory not present' do
        it 'returns hash based on plugins name' do
          expect(plugin.url[:controller]).to eq('refinery/admin/refinery_rspec')
        end
      end
    end

  end
end
