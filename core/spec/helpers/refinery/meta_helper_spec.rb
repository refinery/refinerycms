require 'spec_helper'

module Refinery
  describe MetaHelper do

    describe '#canonical_id' do
      context "when page doesn't exist" do
        let(:page) { nil }

        it 'returns nothing' do
          helper.canonical_id(page).should be_nil
        end
      end

      context 'when page exists' do
        let(:page) { Page.new :slug => 'testing' }

        it "returns the page's canonical slug with '-page' appended" do
          helper.canonical_id(page).should == page.canonical_slug << '-page'
        end
      end
    end

  end
end
