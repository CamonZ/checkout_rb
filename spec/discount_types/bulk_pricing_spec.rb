require 'spec_helper'

RSpec.describe DiscountTypes::BulkPricing, type: :model do
  describe '#total' do

    context 'when the units count is less than min_units' do

      let(:discount_options) { Hash[min_units: 10, percentage: 0.05] }

      it 'returns the base_price * units_count' do
        expect(subject.total(5, 10, discount_options)).to eq(50)
      end
    end

    context 'when the units_count is more than or equal to min_units' do

      let(:discount_options) { Hash[min_units: 3, percentage: 0.05] }

      it 'returns the discounted price by the amount of units' do
        expect(subject.total(3, 20, discount_options)).to eq(57)
      end
    end
  end
end
