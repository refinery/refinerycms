require 'spec_helper'

module Refinery
  describe ThumbnailDimensions, type: :model do
    subject(:dimensions) { described_class.new(geometry, 500, 375) }

    describe '#scale' do
      context 'when no width is supplied' do
        let(:geometry) { 'x225>' }

        it 'scales by height factor' do
          expect(dimensions.width).to eq 300
          expect(dimensions.height).to eq 225
        end
      end
    end
  end
end
