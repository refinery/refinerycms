require "spec_helper"

module Refinery
  describe TranslatedFieldPresenter do
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

    describe "#call" do
      context "when title is present" do
        it "returns it" do
          expect(TranslatedFieldPresenter.new(page).call(:title)).to eq("draft")
        end
      end

      context "when title for current locale isn't available" do
        it "returns existing title from translations" do
          Page.translation_class.where(locale: :en).first.destroy
          expect(TranslatedFieldPresenter.new(page).call(:title)).to eq("melnraksts")
        end
      end
    end
  end
end

