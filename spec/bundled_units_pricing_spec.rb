require 'spec_helper'

RSpec.describe BundledUnitsPricing, type: :model do
  subject { BundledUnitsPricing.new(code: 'VOUCHER', options: { divisor: 3, multiplier: 1 }) }

  describe 'Validations' do
    it { is_expected.to validate_presence_of :code }

    it { is_expected.to validate_uniqueness_of :code }

    it { is_expected.to validate_presence_of :divisor }
    it { is_expected.to validate_presence_of :multiplier }

    it { is_expected.to validate_numericality_of :divisor }
    it { is_expected.to validate_numericality_of :multiplier }
  end

  describe '#price_for' do
    context 'when the units_count is evenly divisable by the bundle_divisor' do
      it 'returns the base_price * bundled_units_count' do
        expect(subject.price_for(5, 3)).to eq(5)
      end
    end

    context 'when the units_count is not evenly divisable by the bundle_divisor' do
      it 'returns the base_price * (bundled_units_count + remainder_units)' do
        expect(subject.price_for(5, 4)).to eq(10)
      end
    end
  end
end
