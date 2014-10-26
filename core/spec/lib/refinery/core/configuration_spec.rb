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
            allow(Refinery::Core).to receive(:site_name).and_return('Test Site Name')
            expect(Refinery::Core.site_name).to eq('Test Site Name')
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
            expect(Refinery::Core.site_name).to eq('I18n Site Name')
          end
        end
      end

      describe 'custom storage backend' do
        it 'class should be nil by default' do
          expect(Refinery::Core.dragonfly_custom_backend_class).to eq(nil)
        end

        context 'is set in core' do
          before { class DummyBackend; end }
          after { Refinery::Core.dragonfly_custom_backend_class = nil }
          let(:backend) { DummyBackend.new }

          it 'and is set to a class that exists' do
            Refinery::Core.dragonfly_custom_backend_class = 'Refinery::Core::DummyBackend'
            expect(Refinery::Core.dragonfly_custom_backend_class).to eq(backend.class)
          end
        end
      end
    end
  end
end
