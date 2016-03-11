require "spec_helper"

module Refinery
  describe TranslationHelper, :type => :helper do

    describe "#t" do
      it "overrides Rails' translation method" do
        expect(helper.t("ugisozols")).to eq("i18n: Ugisozols")
        expect(helper.t("ugisozols.test")).to eq("i18n: Test")
      end
    end

    describe "#translated_field" do
      let(:page) { FactoryGirl.build(:page) }

      before do
        Globalize.with_locale(:en) do
          page.title = "draft"
          page.save!
        end

        Globalize.with_locale(:lv) do
          page.title = "melnraksts"
          page.save!
        end
      end

      context "when title is present" do
        it "returns it" do
          expect(helper.translated_field(page, :title)).to eq("draft")
        end
      end

      context "when title for current locale isn't available" do
        it "returns existing title from translations" do
          Page.translation_class.where(locale: :en).first.destroy
          expect(helper.translated_field(page, :title)).to eq("melnraksts")
        end
      end
    end

  end
end