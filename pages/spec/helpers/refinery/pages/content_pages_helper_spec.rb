require 'spec_helper'

module Refinery
  module Pages
    describe ContentPagesHelper, :type => :helper do
      let(:content_presenter) { double(ContentPresenter, :hide_sections => nil, :fetch_template_overrides => nil, :to_html => nil) }

      describe "when rendering content presenter" do
        it "asks to content presenter to hide sections if told to" do
          expect(content_presenter).to receive(:hide_sections).with(['foo', 'bar'])
          render_content_presenter(content_presenter, :hide_sections => ['foo', 'bar'])
        end

        it "attempts to fetch template overrides declared elsewhere via content_for" do
          expect(content_presenter).to receive(:fetch_template_overrides).and_yield(12)
          expect(self).to receive(:content_for).with(12)
          render_content_presenter(content_presenter)
        end

        it "outputs the html rendered by the content presenter" do
          expect(content_presenter).to receive(:to_html).and_return('foobar')
          expect(render_content_presenter(content_presenter)).to eq('foobar')
        end

        it "passes can_use_fallback option through to html rendering" do
          expect(content_presenter).to receive(:to_html).with(true)
          render_content_presenter(content_presenter, :can_use_fallback => true)
        end
      end

      describe "when rendering page" do
        let(:page) { double(Page) }

        it "builds a content page presenter and returns its html" do
          expect(self).to receive(:page_title).and_return('some title')
          expect(Refinery::Pages::ContentPagePresenter).to receive(:new).with(page, 'some title').and_return(content_presenter)
          expect(content_presenter).to receive(:to_html).and_return('barfoo')

          expect(render_content_page(page)).to eq('barfoo')
        end
      end
    end
  end
end
