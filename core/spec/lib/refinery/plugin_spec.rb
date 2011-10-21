require 'spec_helper'

module Refinery
  module RefineryRspec
    class Engine < ::Rails::Engine
      ::Refinery::Plugin.register do |plugin|
        plugin.name = 'refinery_rspec'
        plugin.url = {:controller => '/admin/dashboard', :action => 'index'}
      end
    end
  end
end

module Refinery
  describe Plugin do

    let(:plugin) { Refinery::Plugins.registered.detect { |plugin| plugin.name == 'refinery_rspec' } }

    def setup_i18n
      ::I18n.backend = ::I18n::Backend::Simple.new
      ::I18n.backend.store_translations :en, :plugins => {
        :refinery_rspec => {
          :title => 'RefineryCMS RSpec',
          :description => 'RSpec tests for plugin.rb'
        }
      }
    end

    describe '.register' do
      it 'must have a name' do
        lambda { Plugin.register {} }.should raise_error
      end
    end

    describe '#class_name' do
      it 'returns class name' do
        plugin.class_name.should == 'RefineryRspec'
      end
    end

    describe '#title' do
      before { setup_i18n }

      it 'returns plugin title defined by I18n' do
        plugin.title.should == 'RefineryCMS RSpec'
      end
    end

    describe '#description' do
      before { setup_i18n }

      it 'returns plugin description defined by I18n' do
        plugin.description.should == 'RSpec tests for plugin.rb'
      end
    end

    describe '#activity' do

    end

    describe '#activity=' do

    end

    describe '#pathname' do
      it 'should be set by default' do
        plugin.pathname.should_not == nil
      end
    end

    describe '#pathname=' do
      it 'converts string input to pathname' do
        plugin.pathname = Rails.root.to_s
        plugin.pathname.should == Rails.root
      end

      it 'overrides the default pathname' do
        current_pathname = plugin.pathname
        new_pathname = current_pathname.join('tmp', 'path')

        current_pathname.should_not == new_pathname

        plugin.pathname = new_pathname
        plugin.pathname.should == new_pathname
      end
    end

    describe '#always_allow_access?' do
      it 'returns false if @always_allow_access is not set or its set to false' do
        plugin.always_allow_access?.should be_false
      end

      it 'returns true if set so' do
        plugin.stub(:always_allow_access?).and_return(true)
        plugin.always_allow_access?.should be
      end
    end

    describe '#dashboard?' do
      it 'returns false if @dashboard is not set or its set to false' do
        plugin.dashboard.should be_false
      end

      it 'returns true if set so' do
        plugin.stub(:dashboard).and_return(true)
        plugin.dashboard.should be
      end
    end

    describe '#menu_match' do
      it 'returns regexp based on plugin name' do
        plugin.menu_match.should == /(admin|refinery)\/refinery_rspec$/
      end
    end

    describe '#highlighted?' do
      it 'returns true if params[:controller] match menu_match regexp' do
        plugin.highlighted?({:controller => 'refinery/refinery_rspec'}).should be
      end

      it 'returns true if dashboard? is true and params[:action] == error_404' do
        plugin.stub(:dashboard?).and_return(true)
        plugin.highlighted?({:action => 'error_404'}).should be
      end
    end

    describe '#url' do
      class Plugin
        def reset_url!
          @url = nil
        end
      end

      before(:each) { plugin.reset_url! }

      context 'when @url is already defined' do
        it 'returns hash' do
          plugin.stub(:url).and_return({:controller => '/admin/testa'})
          plugin.url.should == {:controller => '/admin/testa'}
        end
      end

      context 'when controller is present' do
        it 'returns hash based on it' do
          plugin.stub(:controller).and_return('testb')
          plugin.url.should == {:controller => '/admin/testb'}
        end
      end

      context 'when directory is present' do

        it 'returns hash based on it' do
          plugin.stub(:directory).and_return('first/second/testc')
          plugin.url.should == {:controller => '/admin/testc'}
        end
      end

      context 'when controller and directory not present' do
        it 'returns hash based on plugins name' do
          plugin.url.should == {:controller => '/admin/refinery_rspec'}
        end
      end
    end

  end
end
