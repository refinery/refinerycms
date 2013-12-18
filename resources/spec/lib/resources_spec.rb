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
    before(:all) do
      DummyBackend1 = Class.new
      DummyBackend2 = Class.new
    end

    before(:each) do
      Refinery::Core.stub(:dragonfly_custom_backend_class => DummyBackend1)
    end

    after(:each) do
      described_class.custom_backend_class = nil
    end

    it "uses the default configuration if present" do
      described_class.custom_backend_class.should == DummyBackend1
    end

    it "prefers custom values over the defaults" do
      described_class.custom_backend_class = 'DummyBackend2'
      described_class.custom_backend_class.should == DummyBackend2
    end
  end
end
