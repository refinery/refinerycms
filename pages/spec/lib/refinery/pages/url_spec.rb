require "spec_helper"

module Refinery
  module Pages
    describe Url::Localised do
      describe ".handle?" do
        it "returns true if link_url is present" do
          page = double(:page, :link_url => "/")
          expect(Url::Localised.handle?(page)).to be_truthy
        end
      end

      describe "#url" do
        let(:page) { double(:page, :link_url => "/test") }

        context "when current frontend locale != default frontend locale" do
          it "returns link_url prefixed with current frontend locale" do
            allow(Refinery::I18n).to receive(:current_frontend_locale).and_return(:lv)
            allow(Refinery::I18n).to receive(:default_frontend_locale).and_return(:en)
            expect(Url::Localised.new(page).url).to eq("/lv/test")
          end
        end

        context "when current frontend locale == default frontend locale" do
          it "returns unaltered link_url" do
            allow(Refinery::I18n).to receive(:current_frontend_locale).and_return(:en)
            allow(Refinery::I18n).to receive(:default_frontend_locale).and_return(:en)
            expect(Url::Localised.new(page).url).to eq("/test")
          end
        end
      end
    end

    describe Url::Marketable do
      describe ".handle?" do
        it "returns true if marketable_url config is set to true" do
          page = double(:page)
          allow(Refinery::Pages).to receive(:marketable_url).and_return(true)
          expect(Url::Marketable.handle?(page)).to be_truthy
        end
      end

      describe "#url" do
        it "returns hash" do
          page = double(:page, :nested_url => "test")
          expect(Url::Marketable.new(page).url).to eq({
            :controller => "/refinery/pages", :action => "show", :only_path => true,
            :path => "test", :id => nil
          })
        end
      end
    end

    describe Url::Normal do
      describe ".handle?" do
        it "returns true if to_param is present" do
          page = double(:page, :to_param => "test")
          expect(Url::Normal.handle?(page)).to be_truthy
        end
      end

      describe "#url" do
        it "returns hash" do
          page = double(:page, :to_param => "test")
          expect(Url::Normal.new(page).url).to eq({
            :controller => "/refinery/pages", :action => "show", :only_path => true,
            :path => nil, :id => "test"
          })
        end
      end
    end
  end
end
