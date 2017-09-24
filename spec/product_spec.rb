require 'spec_helper'

RSpec.describe Product, type: :model do

  # Adding a mocked product for the validate_uniqueness_of matcher
  subject { Product.new(name: 'Cabify Awesome t-shirt', code: 'TSHIRT', price: 20.0) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:price) }

  it { is_expected.to validate_uniqueness_of(:code) }
end
