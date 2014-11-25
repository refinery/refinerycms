require "spec_helper"

describe Refinery::Resources do
  describe "with custom s3 settings" do
    it "prefers custom values over the default" do
      Refinery::Core.s3_bucket_name = "kfc"
      described_class.s3_bucket_name = "buckethead"

      expect(described_class.s3_bucket_name).to eq("buckethead")
    end
  end

  describe "without custom s3 settings" do
    it "falls back on defaults" do
      described_class.s3_bucket_name = nil
      Refinery::Core.s3_bucket_name = "kfc"

      expect(described_class.s3_bucket_name).to eq("kfc")
    end
  end

  describe "with a custom storage backend" do
    before(:all) do
      DummyBackend1 = Class.new
      DummyBackend2 = Class.new
    end

    before(:each) do
      allow(Refinery::Core).to receive_messages(:dragonfly_custom_backend_class => DummyBackend1)
    end

    after(:each) do
      described_class.custom_backend_class = nil
    end

    it "uses the default configuration if present" do
      expect(described_class.custom_backend_class).to eq(DummyBackend1)
    end

    it "prefers custom values over the defaults" do
      described_class.custom_backend_class = 'DummyBackend2'
      expect(described_class.custom_backend_class).to eq(DummyBackend2)
    end
  end
end
