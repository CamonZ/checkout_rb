require 'spec_helper'

RSpec.describe DiscountTypes::BulkPricing do
  describe '#total' do

    context 'when the units count is less than min_units' do
      subject { DiscountTypes::BulkPricing.new(min_units: 10, percentage: 0.05) }

      it 'returns the base_price * units_count' do
        expect(subject.total(10, 5)).to eq(50)
      end
    end

    context 'when the units_count is more than or equal to min_units' do
      subject { DiscountTypes::BulkPricing.new(min_units: 3, percentage: 0.05) }

      it 'returns the discounted price by the amount of units' do
        expect(subject.total(20, 3)).to eq(57)
      end
    end
  end
end
