# encoding: utf-8
require 'spec_helper'

module Refinery
  describe Page do
    let(:page_title) { 'RSpec is great for testing too' }
    let(:child_title) { 'The child page' }

    let(:created_page) { subject.class.create!(:title => page_title, :deletable => true) }
    let(:created_child) { created_page.children.create!(:title => child_title) }

    describe '.find_by_path' do
      let(:page_title)  { 'team' }
      let(:child_title) { 'about' }
      let(:created_root_about) { subject.class.create!(:title => child_title, :deletable => true) }

      before do
        # Ensure pages are created.
        created_child
        created_root_about
      end

      it "should return (root) about page when looking for '/about'" do
        expect(Page.find_by_path('/about')).to eq(created_root_about)
      end

      it "should return child about page when looking for '/team/about'" do
        expect(Page.find_by_path('/team/about')).to eq(created_child)
      end
    end

    describe ".find_by_path_or_id" do
      let!(:market) { FactoryGirl.create(:page, :title => "market") }
      let(:path) { "market" }
      let(:id) { market.id }

      context "when path param is present" do
        context "when path is friendly_id" do
          it "finds page using path" do
            expect(Page.find_by_path_or_id(path, "")).to eq(market)
          end
        end

        context "when path is not friendly_id" do
          it "finds page using id" do
            expect(Page.find_by_path_or_id(id, "")).to eq(market)
          end
        end
      end

      context "when id param is present" do
        it "finds page using id" do
          expect(Page.find_by_path_or_id("", id)).to eq(market)
        end
      end
    end

    describe ".find_by_path_or_id!" do
      it "delegates to find_by_path_or_id" do
        lambda do
          expect(Page).to receive(:find_by_path_or_id).with("path", "id")
          Page.find_by_path_or_id!("path", "id")
        end
      end

      it "throws exception when page isn't found" do
        expect { Page.find_by_path_or_id!("not", "here") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end
end
