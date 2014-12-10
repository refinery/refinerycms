require "spec_helper"

module Refinery
  describe AdminHelper, :type => :helper do

    describe "truncate_locale" do
      it "should return the second part of a dialect" do
        expect(helper.truncate_locale('zh-TW')).to eq("TW")
      end

      it "should return the locale if it is not a dialect" do
        expect(helper.truncate_locale('en')).to eq("EN")
      end
    end

   
  end
end
