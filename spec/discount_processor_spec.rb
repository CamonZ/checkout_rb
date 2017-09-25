require 'spec_helper'

RSpec.describe DiscountProcessor do
  subject do
    DiscountProcessor.new(
      [
        {
          code: 'TSHIRT',
          rule: 'bulk_pricing',
          attributes: {
            min_units: 3,
            percentage: 0.05
          }
        },
        {
          code: 'VOUCHER',
          rule: 'bundled_units_pricing',
          attributes: {
            bundle_divisor: 2,
            bundle_multiplier: 1
          }
        }
      ]
    )
  end

  describe "applicable_to?" do
    it 'returns true if there is a rule for the given code' do
      expect(subject.applicable_to?("VOUCHER")).to be true
    end

    it 'returns false if there is no rule for the given code' do
      expect(subject.applicable_to?("MUG")).to be false
    end
  end

  describe "price_for" do
    it "returns the total price for the given strategy" do
      expect(subject.price_for("TSHIRT", 20, 3)).to eq(57)
      expect(subject.price_for("VOUCHER", 5, 3)).to eq(10)
    end
  end
end
