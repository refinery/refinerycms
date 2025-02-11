require "spec_helper"

module Refinery
  describe TranslationHelper, type: :helper do

    describe "#t" do
      it "overrides Rails' translation method" do
        expect(helper.t("ugisozols")).to eq("i18n: Ugisozols")
        expect(helper.t("ugisozols.test")).to eq("i18n: Test")
      end
    end

    describe "#translated_field" do
      let(:page) { FactoryBot.build(:page) }

      before do
        Mobility.with_locale(:en) do
          page.update!({title: 'draft'})
        end

        Mobility.with_locale(:lv) do
          page.title = "melnraksts"
          page.save!
        end
      end

      context "when field for current locale is present" do
        it "it's value is returned" do
          expect(helper.translated_field(page, :title)).to eq("draft")
        end
      end

      context "when field for current locale isn't present" do

        it "returns existing field value from other translations" do
          Page::Translation.where(locale: :en).first.destroy
          expect(helper.translated_field(page, :title)).to eq("melnraksts")
        end
      end
    end

    describe '#locales_with_translated_field' do
      let(:page) { FactoryBot.build(:page) }

      before do
        allow(Refinery::I18n).to receive(:frontend_locales).and_return([:en, :lv, :it])
        Mobility.with_locale(:en) do
          page.update!({title: 'draft'})
        end

        Mobility.with_locale(:lv) do
          page.title = "melnraksts"
          page.save!
        end
      end

      it 'returns an array of locales which have the named field translated' do
        expect(helper.locales_with_translated_field(page, :title)).to eq([:en, :lv])
      end

      context 'The field has no translations' do
        before do
          Refinery::I18n.frontend_locales.each do |locale|
            Mobility.with_locale(locale) do
              page.title = "A title"
              page.menu_title = ""
              page.save!
            end
          end
        end

        it 'returns an empty array' do
          expect(helper.locales_with_translated_field(page, :menu_title)).to eq([])
        end
      end
    end

  end
end
