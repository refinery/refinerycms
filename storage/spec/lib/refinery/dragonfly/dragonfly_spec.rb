require 'spec_helper'

module Refinery
  describe Dragonfly do
    describe 'default configuration' do

      it 'defines a default secret' do
        expect(Refinery::Dragonfly.secret).to_not be nil
      end

      it "doesn't use S3" do
        expect(Refinery::Dragonfly.s3_datastore).to be false
      end

      it "doesn't use a custom datastore" do
        expect(Refinery::Dragonfly.custom_datastore_class).to eq(nil)
      end
    end

    describe 'using custom configuration' do
      describe 'datastore' do
        before {
          class DummyBackend;
          end}
        after {Refinery::Dragonfly.custom_datastore_class = nil}
        let(:datastore) {DummyBackend.new}

        it 'uses the custom setting' do
          Refinery::Dragonfly.custom_datastore_class = DummyBackend
          expect(Refinery::Dragonfly.custom_datastore_class).to eq(datastore.class)
        end
      end
    end
  end
end

