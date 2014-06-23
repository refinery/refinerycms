require "spec_helper"

module Refinery
  describe TranslationHelper, :type => :helper do

    describe "#t" do
      it "overrides Rails' translation method" do
        expect(helper.t("ugisozols")).to eq("i18n: Ugisozols")
        expect(helper.t("ugisozols.test")).to eq("i18n: Test")
      end
    end

  end
end
