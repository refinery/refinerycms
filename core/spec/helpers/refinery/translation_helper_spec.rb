require "spec_helper"

module Refinery
  describe TranslationHelper do

    describe "#t" do
      it "overrides Rails' translation method" do
        helper.t("ugisozols").should eq("i18n: Ugisozols")
        helper.t("ugisozols.test").should eq("i18n: Test")
      end
    end

  end
end
