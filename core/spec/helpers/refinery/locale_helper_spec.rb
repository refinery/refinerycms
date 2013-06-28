require "spec_helper"

module Refinery
  describe LocaleHelper do

    describe "#frontend_locales" do
      it "returns frontend locales which are also specified in Refinery::I18n.locales hash" do
        Refinery::I18n.stub(:frontend_locales).and_return([:en, :lv, :xx])
        Refinery::I18n.stub(:locales).and_return({:en => "English", :lv => "Latviski"})

        expect(helper.frontend_locales).to eq([:en, :lv])
      end
    end

  end
end
