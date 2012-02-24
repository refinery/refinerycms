#encoding: utf-8
require "spec_helper"

module Refinery
  describe MetaHelper do

    describe "#localized_title" do
      context "when some frontend locales are present" do

        it "it gets or set & get a localized site name with default value" do
          ::Refinery::I18n.stub(:config).stub(:frontend_locales => [:ru, :en, :cz, :lv]).each do |loc|
              ::Refinery::I18n.stub(:current_frontend_locale => loc)
              helper.localized_title.should eq "#{loc.to_s} Site Name"
          end
        end

      end

      context "when only default locale is present" do
        it "Returns a sitename in English" do
          helper.localized_title.should eq "en Site Name"
        end
      end

    end

    describe "#browser_title" do

      it "returns a browser title contains localized site name" do
        ::Refinery::I18n.stub(:current_frontend_locale => :ru)
        @meta = "Stubbed to avoid warnings"
        @meta.stub(:browser_title => "Закруглэ")
        helper.browser_title.should =~ /ru Site Name/
      end

      it "returns a base site_name if no I18n module present" do
        ::Refinery.send(:remove_const, :I18n)
        @meta = "Stubbed to avoid warnings"
        @meta.stub(:browser_title => "Закруглэ")
        helper.browser_title.should =~ /- Company Name/
      end


    end

  end
end