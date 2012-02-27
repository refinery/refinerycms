require "spec_helper"

module Refinery
  module Pages
    describe PagePartSectionPresenter do
      it "can be built from a page part" do
        part = double(PagePart, :body => 'part_body', :title => 'A Wonderful Page Part')
        section = PagePartSectionPresenter.new(part)
        section.fallback_html.should == 'part_body'
        section.id.should == :a_wonderful_page_part
      end

      it "marks the body as html safe" do
        part = double(PagePart, :body => '<p>part_body</p>', :title => '')
        section = PagePartSectionPresenter.new(part)
        section.fallback_html.should be_html_safe
        section.wrapped_html.should == "<section id=\"\"><div class=\"inner\"><p>part_body</p></div></section>"
      end
    end
  end
end
