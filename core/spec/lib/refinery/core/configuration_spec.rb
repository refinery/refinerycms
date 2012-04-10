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
    end
  end
end
