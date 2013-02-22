require "spec_helper"

describe  Refinery::Resources do
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
end
