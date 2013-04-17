require "spec_helper"

describe Refinery::Resources do
  describe "with custom s3 settings" do
    it "prefers custom values over the default" do
      Refinery::Core.s3_bucket_name = "kfc"
      described_class.s3_bucket_name = "buckethead"

      described_class.s3_bucket_name.should == "buckethead"
    end
  end

  describe "without custom s3 settings" do
    it "falls back on defaults" do
      described_class.s3_bucket_name = nil
      Refinery::Core.s3_bucket_name = "kfc"

      described_class.s3_bucket_name.should == "kfc"
    end
  end

  describe "with a custom storage backend" do
    before do
      Refinery::Core.dragonfly_custom_backend_class = 'DummyBackend1'
      class DummyBackend1; end
      class DummyBackend2; end
    end
    after { Refinery::Core.dragonfly_custom_backend_class = nil }
    let(:backend1) { DummyBackend1.new }
    let(:backend2) { DummyBackend2.new }

    it "uses the default configuration if present" do
      described_class.custom_backend_class.should == backend1.class
    end

    it "prefers custom values over the defaults" do
      described_class.custom_backend_class = 'DummyBackend2'
      described_class.custom_backend_class.should == backend2.class
    end
  end
end
