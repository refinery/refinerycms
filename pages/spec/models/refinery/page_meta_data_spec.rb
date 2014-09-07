# encoding: utf-8
require 'spec_helper'

module Refinery
  describe Page do
    let(:page_title) { 'RSpec is great for testing too' }
    let(:page) { subject.class.new(:title => page_title, :deletable => true)}

    context 'responds to' do
      it 'meta_description' do
        page.respond_to?(:meta_description)
      end

      it 'browser_title' do
        page.respond_to?(:browser_title)
      end
    end

    context 'allows us to assign to' do
      it 'meta_description' do
        page.meta_description = 'This is my description of the page for search results.'
        page.meta_description.should == 'This is my description of the page for search results.'
      end

      it 'browser_title' do
        page.browser_title = 'An awesome browser title for SEO'
        page.browser_title.should == 'An awesome browser title for SEO'
      end
    end

    context 'allows us to update' do
      it 'meta_description' do
        page.meta_description = 'This is my description of the page for search results.'
        page.save

        page.reload
        page.meta_description.should == 'This is my description of the page for search results.'
      end

      it 'browser_title' do
        page.browser_title = 'An awesome browser title for SEO'
        page.save

        page.reload
        page.browser_title.should == 'An awesome browser title for SEO'
      end
    end
  end
end
