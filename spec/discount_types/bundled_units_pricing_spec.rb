require 'spec_helper'

RSpec.describe DiscountTypes::BundledUnitsPricing, type: :model do
  describe '#total' do
    let(:discount_options) do
      { bundle_divisor: 3, bundle_multiplier: 1 }
    end

    context 'when the units_count is evenly divisable by the bundle_divisor' do
      it 'returns the base_price * bundled_units_count' do
        expect(subject.total(3, 5, discount_options)).to eq(5)
      end
    end

    context 'when the units_count is not evenly divisable by the bundle_divisor' do
      it 'returns the base_price * (bundled_units_count + remainder_units)' do
        expect(subject.total(4, 5, discount_options)).to eq(10)
      end
    end
  end

end
