require "spec_helper"

module Refinery
  describe HtmlTruncationHelper, :type => :helper do

    describe "#truncate" do
      it "returns nil if text is not present" do
        expect(helper.truncate("")).to be_nil
      end

      context "when preserve_html_tags option is present" do
        it "preserve html tags when truncating text" do
          expect(
            helper.truncate(
              "<p>Turducken frankfurter ham hock bacon</p>",
              preserve_html_tags: true
            )
          ).to eq("<p>Turducken frankfurter ham...</p>")
        end
      end

      context "when preserve_html_tags option is not present" do
        it "falls back to original truncate method" do
          expect(TruncateHtml::HtmlTruncator).not_to receive(:new)
          helper.truncate("<p>Turducken frankfurter ham hock bacon</p>").html_safe
        end
      end
    end

  end
end
