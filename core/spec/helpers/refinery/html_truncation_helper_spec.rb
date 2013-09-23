require "spec_helper"

module Refinery
  describe HtmlTruncationHelper do

    describe "#truncate" do
      it "returns nil if text is not present" do
        helper.truncate("").should be_nil
      end

      context "when preserve_html_tags option is present" do
        it "preserve html tags when truncating text" do
          helper.truncate("<p>Turducken frankfurter ham hock bacon</p>",
                          :preserve_html_tags => true).should eq("<p>Turducken frankfurter ham...</p>")
        end
      end

      context "when preserve_html_tags option is not present" do
        it "falls back to original truncate method" do
          helper.truncate("<p>Turducken frankfurter ham hock bacon</p>").html_safe.should 
                 eq("<p>Turducken frankfurter ha...")
        end
      end
    end

  end
end
