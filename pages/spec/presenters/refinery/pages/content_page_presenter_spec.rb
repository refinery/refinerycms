require "spec_helper"

module Refinery
  module Pages
    describe ContentPagePresenter do
      let(:part)  { double(PagePart, :body => 'part_body', :slug => 'a_wonderful_page_part', :title => 'A Wonderful Page Part') }
      let(:part2) { double(PagePart, :body => 'part_body2', :slug => 'a_wonderful_page_part', :title => 'Another Wonderful Page Part') }
      let(:title) { 'This Great Page' }

      describe "when building for page" do
        let(:page_with_one_part) { double(Page, :parts => [part]) }

        it "adds page title section before page parts" do
          content = ContentPagePresenter.new(page_with_one_part, title)
          expect(content.get_section(0).fallback_html).to eq(title)
        end

        it "adds a section for each page part" do
          page = double(Page, :parts => [part, part2])
          content = ContentPagePresenter.new(page, title)
          expect(content.get_section(1).fallback_html).to eq('part_body')
          expect(content.get_section(2).fallback_html).to eq('part_body2')
        end

        it "adds body content left and right after page parts" do
          content = ContentPagePresenter.new(page_with_one_part, title)
          expect(content.get_section(2).id).to eq(:body)
          expect(content.get_section(3).id).to eq(:side_body)
        end

        it "doesnt add page parts if page is nil" do
          content = ContentPagePresenter.new(nil, title)
          expect(content.get_section(1).id).to eq(:body)
        end

        it "doesnt add title if it is blank" do
          content = ContentPagePresenter.new(nil, '')
          expect(content.get_section(0).id).to eq(:body)
        end
      end
    end
  end
end
