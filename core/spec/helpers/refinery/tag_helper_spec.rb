require "spec_helper"

module Refinery
  describe TagHelper, :type => :helper do

    describe "#refinery_help_tag" do
      it "makes title html_safe if it's not already" do
        expect(helper.refinery_help_tag("<br /> ugisozols")).to match(/&lt;br \/&gt; ugisozols/)
      end
    end

    describe "#refinery_icon_tag" do
      it "appends .png to filename if specified string has no dots in it" do
        expect(helper.refinery_icon_tag("ugisozols")).to match(/ugisozols\.png/)
      end

      it "wraps image_tag with some options preset" do
        expect(helper.refinery_icon_tag("ugis.ozols.jpg")).to xml_eq(%Q{<img alt="Ugis.ozols" height="16" src="/images/refinery/icons/ugis.ozols.jpg" width="16" />})
      end
    end

  end
end
