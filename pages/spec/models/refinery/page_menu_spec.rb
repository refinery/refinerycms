# encoding: utf-8
require 'spec_helper'

module Refinery
  describe Page do
    let(:page_title) { 'RSpec is great for testing too' }
    let(:page) { subject.class.new(:title => page_title, :deletable => true)}

    describe "#to_refinery_menu_item" do
      let(:page) do
        Page.new(
          :id => 5,
          :parent_id => 8,
          :menu_match => "^/foo$"

        # Page does not allow setting lft and rgt, so stub them.
        ).tap do |p|
          p[:lft] = 6
          p[:rgt] = 7
        end
      end

      subject { page.to_refinery_menu_item }

      shared_examples_for("Refinery menu item hash") do
        [ [:id, 5],
          [:lft, 6],
          [:rgt, 7],
          [:parent_id, 8],
          [:menu_match, "^/foo$"]
        ].each do |attr, value|
          it "returns the correct :#{attr}" do
            subject[attr].should eq(value)
          end
        end

        it "returns the correct :url" do
          subject[:url].should be_a(Hash) # guard against nil
          subject[:url].should eq(page.url)
        end
      end

      context "with #menu_title" do
        before do
          page[:menu_title] = "Menu Title"
        end

        it_should_behave_like "Refinery menu item hash"

        it "returns the menu_title for :title" do
          subject[:title].should eq("Menu Title")
        end
      end

      context "with #title" do
        before do
          page[:title] = "Title"
        end

        it_should_behave_like "Refinery menu item hash"

        it "returns the title for :title" do
          subject[:title].should eq("Title")
        end
      end
    end

    describe "#in_menu?" do
      context "when live? and show_in_menu? returns true" do
        it "returns true" do
          page.stub(:live?).and_return(true)
          page.stub(:show_in_menu?).and_return(true)
          page.in_menu?.should be_true
        end
      end

      context "when live? or show_in_menu? doesn't return true" do
        it "returns false" do
          page.stub(:live?).and_return(true)
          page.stub(:show_in_menu?).and_return(false)
          page.in_menu?.should be_false

          page.stub(:live?).and_return(false)
          page.stub(:show_in_menu?).and_return(true)
          page.in_menu?.should be_false
        end
      end
    end

    describe "#not_in_menu?" do
      context "when in_menu? returns true" do
        it "returns false" do
          page.stub(:in_menu?).and_return(true)
          page.not_in_menu?.should be_false
        end
      end

      context "when in_menu? returns false" do
        it "returns true" do
          page.stub(:in_menu?).and_return(false)
          page.not_in_menu?.should be_true
        end
      end
    end

  end
end
