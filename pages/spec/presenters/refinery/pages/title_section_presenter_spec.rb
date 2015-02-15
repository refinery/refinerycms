require "spec_helper"

module Refinery
  module Pages
    describe TitleSectionPresenter do
      describe "when building html for a section" do
        it "wraps a title section in a title element" do
          section = TitleSectionPresenter.new(:fallback_html => 'foobar')
          expect(section.has_content?(true)).to be_truthy
          expect(section.wrapped_html(true)).to xml_eq('<h1>foobar</h1>')
        end

        it "will use the specified id" do
          section = TitleSectionPresenter.new(:fallback_html => 'foobar', :id => 'mynode')
          expect(section.has_content?(true)).to be_truthy
          expect(section.wrapped_html(true)).to xml_eq('<h1 id="mynode">foobar</h1>')
        end
      end
    end
  end
end
