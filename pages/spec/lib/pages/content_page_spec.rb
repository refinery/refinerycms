require "spec_helper"

module Refinery
  module Pages
    describe ContentPage do
      let(:part)  { double(PagePart, :body => 'part_body', :title => 'A Wonderful Page Part') }
      let(:part2) { double(PagePart, :body => 'part_body2', :title => 'Another Wonderful Page Part') }
      let(:title) { 'This Great Page' }
      let(:section1) { double(SectionPresenter, :id => 'foo') }
      let(:section2) { double(SectionPresenter, :id => 'bar') }

      describe "when building for page" do
        let(:page_with_one_part) { double(Page, :parts => [part]) }

        it "adds page title section before page parts" do
          content = ContentPage.build_for_page(page_with_one_part, title)
          content.get_section(0).fallback_html.should == title
        end

        it "adds a section for each page part" do
          page = double(Page, :parts => [part, part2])
          content = ContentPage.build_for_page(page, title)
          content.get_section(1).fallback_html.should == 'part_body'
          content.get_section(2).fallback_html.should == 'part_body2'
        end

        it "adds body content left and right after page parts" do
          content = ContentPage.build_for_page(page_with_one_part, title)
          content.get_section(2).id.should == :body_content_left
          content.get_section(3).id.should == :body_content_right
        end

        it "doesnt add page parts if page is nil" do
          content = ContentPage.build_for_page(nil, title)
          content.get_section(1).id.should == :body_content_left
        end

        it "doesnt add title if it is blank" do
          content = ContentPage.build_for_page(nil, '')
          content.get_section(0).id.should == :body_content_left
        end
      end

      describe "when building css classes for blank sections" do
        let(:section) { double(SectionPresenter, :not_present_css_class => 'no_section1') }

        it "includes css class for any section which doesnt have content" do
          section.stub(:has_content?).with(true).and_return(false)
          content = ContentPage.new
          content.add_section section

          content.blank_section_css_classes(true).should == ['no_section1']
        end

        it "doesnt include sections which have content" do
          section.stub(:has_content?).with(true).and_return(true)
          content = ContentPage.new
          content.add_section section

          content.blank_section_css_classes(true).should be_empty
        end
      end

      describe "when hiding sections" do
        before do
          @content = ContentPage.new
          @content.add_section section1
          @content.add_section section2
        end

        it "hides a section specified by id" do
          section2.should_receive(:hide)
          @content.hide_sections('bar')
        end
      end

      describe "when fetching template overrides" do
        before do
          @content = ContentPage.new
        end

        it "yields a section with an id and stores the result in its override html" do
          section = double(SectionPresenter, :id => 'foo')
          section.should_receive(:override_html=).with('some override')
          @content.add_section section

          @content.fetch_template_overrides do |section_id|
            section_id.should == 'foo'
            'some override'
          end
        end

        it "doesnt yield a section without an id" do
          section = double(SectionPresenter, :id => nil)
          section.should_receive(:override_html=).never
          @content.add_section section

          @content.fetch_template_overrides do |section_id|
            raise "this should not occur"
          end
        end
      end

      describe "when rendering as html" do
        it "is blank if it has no sections" do
          content = ContentPage.new
          content.to_html.should be_blank
        end

        it "returns sections joined by a newline" do
          section1.stub(:wrapped_html).and_return('foo')
          section2.stub(:wrapped_html).and_return('bar')
          content = ContentPage.new([section1, section2])
          content.to_html.should == "foo\nbar"
        end

        it "passes allowed_to_use_fallback option on to sections" do
          section1.should_receive(:wrapped_html).with(false).and_return('foo')
          content = ContentPage.new([section1])
          content.to_html(false)
        end
      end
    end
  end
end
