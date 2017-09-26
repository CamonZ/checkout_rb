require 'spec_helper'

RSpec.describe BulkPricing, type: :model do
  describe 'Validations' do
    subject { BulkPricing.new(code: 'TSHIRT', options: { min_units: 5, percentage: 0.05 }) }

    it { is_expected.to validate_presence_of :code }

    it { is_expected.to validate_uniqueness_of :code }

    it { is_expected.to validate_presence_of :min_units }
    it { is_expected.to validate_presence_of :percentage }

    it { is_expected.to validate_numericality_of :min_units }
    it { is_expected.to validate_numericality_of(:percentage).is_greater_than(0).is_less_than_or_equal_to(1) }
  end


  describe '#price_for' do

    context 'when the units count is less than min_units' do
      subject { BulkPricing.new(code: 'TSHIRT', options: { min_units: 10, percentage: 0.05 }) }

      it 'returns the base_price * units_count' do
        expect(subject.price_for(10, 6)).to eq(60)
      end
    end

    context 'when the units_count is more than or equal to min_units' do
      subject { BulkPricing.new(code: 'TSHIRT', options: { min_units: 3, percentage: 0.05 }) }

      it 'returns the discounted price by the amount of units' do
        expect(subject.price_for(20, 3)).to eq(57)
      end
    end
  end
end
