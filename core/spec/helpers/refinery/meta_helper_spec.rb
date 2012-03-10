#encoding: utf-8
require "spec_helper"

module Refinery
  describe MetaHelper do

    before(:each) do
      ::Refinery::Core.config.stub(:site_name => {:ru => 'Сайт Гургена', :en => 'Simple Site', :cz => 'dvěma', :lv => 'isinājumi ar dažādu'})
      @meta = "Stubbed to avoid warnings"
      @meta.stub(:browser_title => "Лапсердак")
    end

    describe "#browser_title" do

      it "returns a browser title contains localized site name" do
        ::Refinery::I18n.stub(:current_frontend_locale => :ru)
        helper.browser_title.should eq "Лапсердак - Сайт Гургена"
      end

      context "when some frontend locales are present" do
        it "returns a string from site_name hash, according to requested locale" do
          ::Refinery::I18n.config.stub(:frontend_locales => [:ru, :en, :cz, :lv])
          ::Refinery::I18n.config.frontend_locales.each do |loc|
            ::Refinery::I18n.stub(:current_frontend_locale => loc)
            helper.browser_title.should eq "Лапсердак - #{::Refinery::Core.config.site_name[::Refinery::I18n.current_frontend_locale]}"
          end
        end
      end

      context "when only default locale is present" do
        it "returns a sitename in English" do
          ::Refinery::Core.config.stub(:site_name => {en: "Company Name"})
          helper.browser_title.should eq "Лапсердак - Company Name"
        end
      end

      context "when requested locale is not present in site_name hash" do
        it "returns English sitename" do
          ::Refinery::I18n.stub(:current_frontend_locale => :jp)
          helper.browser_title.should eq "Лапсердак - Simple Site"
        end
      end

      context "when default_locale not equal to en" do
        it "returns an en site_name if cannot find default locale key" do
          ::Refinery::Core.config.stub(:site_name => {:en => 'Simple Site'})
          ::Refinery::I18n.stub(:default_locale => :ru)
          ::Refinery::I18n.stub(:current_frontend_locale => :ru)
          helper.browser_title.should eq "Лапсердак - Simple Site"
        end
      end

    end

  end

end
