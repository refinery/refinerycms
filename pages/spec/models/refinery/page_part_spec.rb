# encoding: utf-8
require 'spec_helper'

module Refinery
  describe Page do
    let(:page_title) { 'RSpec is great for testing too' }
    let(:page) { subject.class.new(:title => page_title, :deletable => true)}

    before do
      page.parts.new(:title => 'body', :content => "I'm the first page part for this page.", :position => 0)
      page.parts.new(:title => 'side body', :content => 'Closely followed by the second page part.', :position => 1)
    end

    it 'return the content when using content_for' do
      page.content_for(:body).should == "<p>I'm the first page part for this page.</p>"
      page.content_for('BoDY').should == "<p>I'm the first page part for this page.</p>"
    end

    it 'requires a unique title' do
      page.save
      page.parts.create(:title => 'body')
      duplicate_title_part = page.parts.create(:title => 'body')

      duplicate_title_part.errors[:title].should be_present
    end

    it 'only requires a unique title on the same page' do
      part_one = Page.create(:title => 'first page').parts.create(:title => 'body')
      part_two = Page.create(:title => 'second page').parts.create(:title => 'body')

      part_two.errors[:title].should be_empty
    end

    context 'when using content_for?' do

      it 'return true when page part has content' do
        page.content_for?(:body).should be_true
      end

      it 'return false when page part does not exist' do
        page.parts = []
        page.content_for?(:body).should be_false
      end

      it 'return false when page part does not have any content' do
        page.parts.first.content = ''
        page.content_for?(:body).should be_false
      end

    end

    it 'reposition correctly' do
      page.save

      page.parts.first.update_columns position: 6
      page.parts.last.update_columns position: 4

      page.parts.first.position.should == 6
      page.parts.last.position.should == 4

      page.reposition_parts!

      page.parts.first.position.should == 0
      page.parts.last.position.should == 1
    end
  end
end
