require 'spec_helper'

module Refinery
  module Pages
    describe ContentPagesHelper do
      let(:content_presenter) { double(ContentPresenter, :hide_sections => nil, :fetch_template_overrides => nil, :to_html => nil) }

      describe "when rendering content presenter" do
        it "asks to content presenter to hide sections if told to" do
          content_presenter.should_receive(:hide_sections).with(['foo', 'bar'])
          render_content_presenter(content_presenter, :hide_sections => ['foo', 'bar'])
        end

        it "attempts to fetch template overrides declared elsewhere via content_for" do
          content_presenter.should_receive(:fetch_template_overrides).and_yield(12)
          self.should_receive(:content_for).with(12)
          render_content_presenter(content_presenter)
        end

        it "outputs the html rendered by the content presenter" do
          content_presenter.should_receive(:to_html).and_return('foobar')
          render_content_presenter(content_presenter).should == 'foobar'
        end

        it "passes can_use_fallback option through to html rendering" do
          content_presenter.should_receive(:to_html).with(true)
          render_content_presenter(content_presenter, :can_use_fallback => true)
        end
      end

      describe "when rendering page" do
        let(:page) { double(Page) }

        it "builds a content page presenter and returns its html" do
          self.should_receive(:page_title).and_return('some title')
          Refinery::Pages::ContentPagePresenter.should_receive(:new).with(page, 'some title').and_return(content_presenter)
          content_presenter.should_receive(:to_html).and_return('barfoo')

          render_content_page(page).should == 'barfoo'
        end
      end
    end
  end
end