require "spec_helper"

module Refinery
  module Pages
    describe ContentPresenter do
      let(:section1) { double(SectionPresenter, :id => 'foo', :has_content? => true) }
      let(:section2) { double(SectionPresenter, :id => 'bar', :has_content? => true) }

      describe "when building css classes for blank sections" do
        let(:section) { double(SectionPresenter, :not_present_css_class => 'no_section1') }

        it "includes css class for any section which doesnt have content" do
          allow(section).to receive(:has_content?).with(true).and_return(false)
          content = ContentPresenter.new
          content.add_section section

          expect(content.blank_section_css_classes(true)).to eq(['no_section1'])
        end

        it "doesnt include sections which have content" do
          allow(section).to receive(:has_content?).with(true).and_return(true)
          content = ContentPresenter.new
          content.add_section section

          expect(content.blank_section_css_classes(true)).to be_empty
        end
      end

      describe "when hiding sections" do
        before do
          @content = ContentPresenter.new
          @content.add_section section1
          @content.add_section section2
        end

        it "hides a section specified by id" do
          expect(section2).to receive :hide
          @content.hide_sections 'bar'
        end

        # Regression for https://github.com/refinery/refinerycms/issues/1516
        it "accepts an array" do
          expect(section2).to receive :hide
          @content.hide_sections ['bar']
        end

        it "hides nothing if nil" do
          allow(section1).to receive(:hidden?).and_return false
          allow(section2).to receive(:hidden?).and_return false
          @content.hide_sections nil
          expect(@content.hidden_sections.count).to eq(0)
        end

      end

      describe "when fetching template overrides" do
        before do
          @content = ContentPresenter.new
        end

        it "yields a section with an id and stores the result in its override html" do
          section = double(SectionPresenter, :id => 'foo')
          expect(section).to receive(:override_html=).with('some override')
          @content.add_section section

          @content.fetch_template_overrides do |section_id|
            expect(section_id).to eq('foo')
            'some override'
          end
        end

        it "doesnt yield a section without an id" do
          section = double(SectionPresenter, :id => nil)
          expect(section).to receive(:override_html=).never
          @content.add_section section

          @content.fetch_template_overrides do |section_id|
            raise "this should not occur"
          end
        end
      end

      describe "when rendering as html" do
        it "is empty section tag if it has no sections" do
          content = ContentPresenter.new
          expect(content.to_html).to xml_eq(%q{<section class="" id="body_content"></section>})
        end

        it "returns sections joined by a newline inside section tag" do
          allow(section1).to receive(:wrapped_html).and_return('foo')
          allow(section2).to receive(:wrapped_html).and_return('bar')
          content = ContentPresenter.new([section1, section2])
          expect(content.to_html).to xml_eq(%Q{<section class="" id="body_content">foo\nbar</section>})
        end

        it "passes can_use_fallback option on to sections" do
          expect(section1).to receive(:wrapped_html).with(false).and_return('foo')
          content = ContentPresenter.new([section1])
          content.to_html(false)
        end

        it "doesnt include sections with nil content" do
          allow(section1).to receive(:wrapped_html).and_return('foo')
          allow(section2).to receive(:wrapped_html).and_return(nil)
          content = ContentPresenter.new([section1, section2])
          expect(content.to_html).to xml_eq(%q{<section class="" id="body_content">foo</section>})
        end
      end
    end
  end
end
