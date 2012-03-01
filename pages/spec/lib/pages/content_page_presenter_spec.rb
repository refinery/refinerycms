require "spec_helper"

module Refinery
  module Pages
    describe ContentPagePresenter do
      let(:part)  { double(PagePart, :body => 'part_body', :title => 'A Wonderful Page Part') }
      let(:part2) { double(PagePart, :body => 'part_body2', :title => 'Another Wonderful Page Part') }
      let(:title) { 'This Great Page' }

      describe "when building for page" do
        let(:page_with_one_part) { double(Page, :parts => [part]) }

        it "adds page title section before page parts" do
          content = ContentPagePresenter.new(page_with_one_part, title)
          content.get_section(0).fallback_html.should == title
        end

        it "adds a section for each page part" do
          page = double(Page, :parts => [part, part2])
          content = ContentPagePresenter.new(page, title)
          content.get_section(1).fallback_html.should == 'part_body'
          content.get_section(2).fallback_html.should == 'part_body2'
        end

        it "adds body content left and right after page parts" do
          content = ContentPagePresenter.new(page_with_one_part, title)
          content.get_section(2).id.should == :body_content_left
          content.get_section(3).id.should == :body_content_right
        end

        it "doesnt add page parts if page is nil" do
          content = ContentPagePresenter.new(nil, title)
          content.get_section(1).id.should == :body_content_left
        end

        it "doesnt add title if it is blank" do
          content = ContentPagePresenter.new(nil, '')
          content.get_section(0).id.should == :body_content_left
        end
      end
    end
  end
end
