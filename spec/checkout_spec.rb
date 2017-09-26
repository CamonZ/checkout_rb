require 'spec_helper'

RSpec.describe Checkout do
  let(:default_rules) do
    [
      BulkPricing.new(code: 'TSHIRT', options: { min_units: 3, percentage: 0.05 }),
      BundledUnitsPricing.new(code: 'VOUCHER', options: { divisor: 2, multiplier: 1})
    ]
  end

  before(:all) do
    Product.create(name: 'Cabify Awesome T-Shirt', code: 'TSHIRT', price: 20.0)
    Product.create(name: 'Cabify Awesome Mug', code: 'MUG', price: 7.5)
    Product.create(name: 'Cabify Awesome Voucher', code: 'VOUCHER', price: 5.0)
  end

  subject { Checkout.new(default_rules) }

  describe 'Saves products scanned during the checkout process' do
    it 'saves the product code' do
      subject.scan('TSHIRT')
      expect(subject.products).to have_key('TSHIRT')
      expect(subject.products['TSHIRT']).to eq(1)
    end

    it 'increments the counter on an existing product code' do
      subject.scan('TSHIRT')
      expect(subject.products['TSHIRT']).to eq(1)

      subject.scan('TSHIRT')
      expect(subject.products['TSHIRT']).to eq(2)
    end

    it 'saves multiple product codes' do
      subject.scan('TSHIRT')
      subject.scan('MUG')

      expect(subject.products['TSHIRT']).to eq(1)
      expect(subject.products['MUG']).to eq(1)
    end
  end

  describe 'Applies the pricing rules to the scanned items' do
    it 'sums the total when there are no repeat items' do
      subject.scan('VOUCHER')
      subject.scan('TSHIRT')
      subject.scan('MUG')

      expect(subject.total).to eq(32.50)
    end

    it 'sums the total when applying a 2x1 discount on VOUCHER items' do
      subject.scan('VOUCHER')
      subject.scan('TSHIRT')
      subject.scan('VOUCHER')

      expect(subject.total).to eq(25.00)
    end

    it 'sums the total when doing a bulk discount on TSHIRT items' do
      subject.scan('TSHIRT')
      subject.scan('TSHIRT')
      subject.scan('TSHIRT')
      subject.scan('VOUCHER')
      subject.scan('TSHIRT')

      expect(subject.total).to eq(81.00)
    end

    it 'sums the total when applying multiple pricing rules' do
      subject.scan('VOUCHER')
      subject.scan('TSHIRT')
      subject.scan('VOUCHER')
      subject.scan('VOUCHER')
      subject.scan('MUG')
      subject.scan('TSHIRT')
      subject.scan('TSHIRT')

      expect(subject.total).to eq(74.50)
    end
  end
end
