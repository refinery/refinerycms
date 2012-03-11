#encoding: utf-8
require "spec_helper"

module Refinery
  describe MetaHelper do

    before(:each) do
      @meta = "Stubbed to avoid warnings"
      @meta.stub(:browser_title => "Лапсердак")
    end

    describe "#browser_title" do

      it "returns a browser title contains localized site name" do
        %w(:ru :cz :piggy).each do |loc|
          ::I18n.stub(:t).with("site_name", :scope=>"refinery.core.config").and_return "#{loc.to_s} Site Name"
          helper.browser_title.should eq "Лапсердак - #{loc.to_s} Site Name"
        end
      end

      context "when choosen locale has no key in current locale file" do
        it "returns default sitename in english" do
          ::I18n.locale = :fr
          helper.browser_title.should eq "Лапсердак - Company Name"
        end
      end

    end

  end

end
