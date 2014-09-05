# encoding: utf-8
require 'spec_helper'

module Refinery
  describe Page do
    let(:page_title) { 'RSpec is great for testing too' }
    let(:page) { subject.class.new(:title => page_title, :deletable => true)}

    def page_cannot_be_destroyed
      page.should_receive(:puts_destroy_help)
      page.destroy.should == false
    end

    context 'cannot be deleted under certain rules' do
      it 'if link_url is present' do
        page.link_url = '/plugin-name'
        page_cannot_be_destroyed
      end

      it 'if refinery team deems it so' do
        page.deletable = false
        page_cannot_be_destroyed
      end

      it 'if menu_match is present' do
        page.menu_match = "^/#{page_title}*$"
        page_cannot_be_destroyed
      end

      it 'unless you really want it to! >:]' do
        page.deletable = false
        page_cannot_be_destroyed
        page.destroy!.should be
      end

      it "even if you really want it to AND it's saved! >:]" do
        page.update_attribute(:deletable, false)
        page_cannot_be_destroyed
        page.destroy!.should be
      end
    end

    context 'draft pages' do
      it 'not live when set to draft' do
        page.draft = true
        page.live?.should_not be
      end

      it 'live when not set to draft' do
        page.draft = false
        page.live?.should be
      end
    end

    describe "#deletable?" do
      let(:deletable_page) do
        page.deletable  = true
        page.link_url   = ""
        page.menu_match = ""
        page.stub(:puts_destroy_help).and_return('')
        page
      end

      context "when deletable is true and link_url, and menu_match is blank" do
        it "returns true" do
          deletable_page.deletable?.should be_true
        end
      end

      context "when deletable is false and link_url, and menu_match is blank" do
        it "returns false" do
          deletable_page.deletable = false
          deletable_page.deletable?.should be_false
        end
      end

      context "when deletable is false and link_url or menu_match isn't blank" do
        it "returns false" do
          deletable_page.deletable  = false
          deletable_page.link_url   = "text"
          deletable_page.deletable?.should be_false

          deletable_page.menu_match = "text"
          deletable_page.deletable?.should be_false
        end
      end
    end

    describe "#destroy" do
      before do
        page.deletable  = false
        page.link_url   = "link_url"
        page.menu_match = "menu_match"
        page.save!
      end

      it "shows message" do
        page.should_receive(:puts_destroy_help)

        page.destroy
      end
    end
  end
end
