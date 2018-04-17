require 'spec_helper'

module Refinery
  describe Storage do
    describe 'default configuration' do

      it 'defines a default secret' do
        expect(Refinery::Storage.secret).to_not be nil
      end

      it "doesn't use S3" do
        expect(Refinery::Storage.s3_datastore).to be false
      end

      it "doesn't use a custom datastore" do
        expect(Refinery::Storage.custom_datastore_class).to eq(nil)
      end
    end

    describe 'using custom configuration' do
      describe 'datastore' do
        before {
          class DummyBackend;
          end}
        after {Refinery::Storage.custom_datastore_class = nil}
        let(:datastore) {DummyBackend.new}

        it 'uses the custom setting' do
          Refinery::Storage.custom_datastore_class = DummyBackend
          expect(Refinery::Storage.custom_datastore_class).to eq(datastore.class)
        end
      end
    end
  end
end

