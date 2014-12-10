require "spec_helper"

module Refinery
  describe AdminHelper, :type => :helper do
    describe "locale_country" do
      it "should return the second part of a dialect" do
        expect(helper.locale_country('zh-TW')).to eq("TW")
      end

      it "should return the locale if it is not a dialect" do
        expect(helper.locale_country('en')).to eq("EN")
      end
    end
  end
end
