require 'spec_helper'

RSpec.describe DiscountTypes::BundledUnitsPricing do
  describe '#total' do
    subject { DiscountTypes::BundledUnitsPricing.new(bundle_divisor: 3, bundle_multiplier: 1) }

    context 'when the units_count is evenly divisable by the bundle_divisor' do
      it 'returns the base_price * bundled_units_count' do
        expect(subject.total(5, 3)).to eq(5)
      end
    end

    context 'when the units_count is not evenly divisable by the bundle_divisor' do
      it 'returns the base_price * (bundled_units_count + remainder_units)' do
        expect(subject.total(5, 4)).to eq(10)
      end
    end
  end

end
