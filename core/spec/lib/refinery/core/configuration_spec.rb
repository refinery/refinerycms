require 'spec_helper'

module Refinery
  module Core
    describe 'configuration' do
      describe '.site_name' do
        # reset any previously defined site name
        before do
          Refinery::Core.site_name = nil
        end

        context 'when set in configuration' do
          it 'returns name set by Refinery::Core.config' do
            Refinery::Core.stub(:site_name).and_return('Test Site Name')
            Refinery::Core.site_name.should eq('Test Site Name')
          end
        end

        context 'when set in locale file' do
          before do
            ::I18n.backend.store_translations :en, :refinery => {
              :core => {
                :config => {
                  :site_name => 'I18n Site Name'
                }
              }
            }
          end

          it 'returns name set in locale' do
            Refinery::Core.site_name.should eq('I18n Site Name')
          end
        end
      end
  
      context 'Rack::Cache middleware' do
        subject { ::Rails.application.config }
        it 'should be configured via Rails' do
          subject.action_dispatch.rack_cache.should have_key(:metastore)
          subject.action_dispatch.rack_cache.should have_key(:entitystore)
        end
        it 'should be included once and only once' do
          count = 0
          subject.middleware.each do |middleware|
            count += 1 if middleware === Rack::Cache
          end
          count.should == 1
        end
      end
    end
  end
end
