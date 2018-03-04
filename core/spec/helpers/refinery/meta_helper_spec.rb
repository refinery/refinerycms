require 'spec_helper'

module Refinery
  describe MetaHelper, type: :helper do

    describe '#canonical_id' do
      context "when page doesn't exist" do
        let(:page) { nil }

        it 'returns nothing' do
          expect(helper.canonical_id(page)).to be_nil
        end
      end

      context 'when page exists' do
        let(:page) { Page.new slug: 'testing' }

        it "returns the page's canonical slug with '-page' appended" do
          expect(helper.canonical_id(page)).to eq(page.canonical_slug << '-page')
        end
      end
    end

    describe '#view_template_class' do
      context "when page doesn't exist" do
        let(:page) { nil }

        it 'returns nothing' do
          expect(helper.view_template_class(page)).to be_nil
        end
      end

      context 'when page exists' do
        let(:page) { Page.new slug: 'testing', view_template: 'home' }

        it "returns the page's view_template with 'template-' prepended" do
          expect(helper.view_template_class(page)).to eq('template-' << page.view_template)
        end
      end
    end

  end
end
