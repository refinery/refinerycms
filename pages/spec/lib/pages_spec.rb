require "spec_helper"

module Refinery
  describe Pages do
    describe ".valid_templates" do
      before do
        File.open(File.join(subject.root, "spec", "ugisozols.html"), "w+") do
        end
      end

      after { File.delete(File.join(subject.root, "spec", "ugisozols.html")) }

      context "when pattern match valid templates" do
        it "returns an array of valid templates" do
          subject.valid_templates('spec', '*html*').should include("ugisozols")
        end
      end

      context "when pattern doesn't match valid templates" do
        it "returns empty array" do
          subject.valid_templates('huh', '*html*').should == []
        end
      end
    end
  end
end
