require 'checkout'

RSpec.describe Checkout do
  let(:default_rules) { {} }
  subject {Checkout.new(default_rules) }

  it "sums correctly individual items" do

    subject.scan("VOUCHER")
    subject.scan("TSHIRT")
    subject.scan("MUG")

    expect(subject.total).to eq(32.50)
  end

  it "applies the 2x1 discount on VOUCHER items" do
    subject.scan("VOUCHER")
    subject.scan("TSHIRT")
    subject.scan("VOUCHER")

    expect(subject.total).to eq(25.00)
  end

  it "applies the bulk discount on TSHIRT items" do
    subject.scan("TSHIRT")
    subject.scan("TSHIRT")
    subject.scan("TSHIRT")
    subject.scan("VOUCHER")
    subject.scan("TSHIRT")

    expect(subject.total).to eq(81.00)
  end

  it "applies the different discounts on a multi-items checkout" do
    subject.scan("VOUCHER")
    subject.scan("TSHIRT")
    subject.scan("VOUCHER")
    subject.scan("VOUCHER")
    subject.scan("MUG")
    subject.scan("TSHIRT")
    subject.scan("TSHIRT")

    expect(subject.total).to eq(74.50)
  end
end
