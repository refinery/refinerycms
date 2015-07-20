require "spec_helper"

module Refinery
  module Pages
    describe PagePartSectionPresenter do
      it "can be built from a page part" do
        part = double(PagePart, :body => 'part_body', :slug => 'a_wonderful_page_part', :title => 'A Wonderful Page Part')
        section = PagePartSectionPresenter.new(part)
        expect(section.fallback_html).to eq('part_body')
        expect(section.id).to eq(:a_wonderful_page_part)
      end

      it "marks the body as html safe" do
        part = double(PagePart, :body => '<p>part_body</p>', :slug => nil, :title => nil)
        section = PagePartSectionPresenter.new(part)
        expect(section.fallback_html).to be_html_safe
        expect(section.wrapped_html).to xml_eq(%q{<section><div class="inner"><p>part_body</p></div></section>})
      end

      it "handles a nil page body" do
        part = double(PagePart, :body => nil, :slug => nil, :title => nil)
        section = PagePartSectionPresenter.new(part)
        expect(section.fallback_html).to be_nil
        expect(section.wrapped_html).to be_nil
        expect(section.has_content?).to be_falsey
      end

      it "has no id if title is nil" do
        part = double(PagePart, :body => 'foobar', :slug => nil, :title => nil)
        section = PagePartSectionPresenter.new(part)
        expect(section.id).to be_nil
      end
    end
  end
end
