#encoding: utf-8
require "spec_helper"

module Refinery
  describe MetaHelper do

    before(:each) do
      ::Refinery::Core.config.stub(:site_name => {:ru => 'Сайт Гургена', :en => 'Simple Site', :cz => 'dvěma', :lv => 'isinājumi ar dažādu'})
    end

    describe "#localized_title" do
      context "when some frontend locales are present" do

        it "it returns a string from site_name hash, according to requested locale" do
          ::Refinery::I18n.config.stub(:frontend_locales => [:ru, :en, :cz, :lv])
          ::Refinery::I18n.config.frontend_locales.each do |loc|
            ::Refinery::I18n.stub(:current_frontend_locale => loc)
            helper.localized_title.should eq ::Refinery::Core.config.site_name[::Refinery::I18n.current_frontend_locale]
          end
        end

      end

      context "when only default locale is present" do
        it "Returns a sitename in English" do
          ::Refinery::Core.config.stub(:site_name => "Company Name")
          helper.localized_title.should eq "Company Name"
        end
      end

      context "when requested locale is not present in site_name hash" do
        it "Returns mocked default sitename with locale prefix" do
          ::Refinery::I18n.stub(:current_frontend_locale => :jp)
          helper.localized_title.should eq "#{::Refinery::I18n.current_frontend_locale} Company Name"
        end
      end

    end

    describe "#browser_title" do

      it "returns a browser title contains localized site name" do
        ::Refinery::I18n.stub(:current_frontend_locale => :ru)
        @meta = "Stubbed to avoid warnings"
        @meta.stub(:browser_title => "Закруглэ")
        helper.browser_title.should =~ /- Сайт Гургена/
      end

      it "returns a base site_name if no I18n module present" do
        ::Refinery::Core.config.stub(:site_name => "Company Name")
        ::Refinery.send(:remove_const, :I18n)
        @meta = "Stubbed to avoid warnings"
        @meta.stub(:browser_title => "Закруглэ")
        helper.browser_title.should =~ /- Company Name/
      end

    end

  end

end
