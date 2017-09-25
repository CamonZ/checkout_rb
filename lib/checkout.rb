require 'active_support'
require 'product'

class Checkout
  attr_reader :products

  def initialize(pricing_rules)
    @products = {}
    @discounts = DiscountProcessor.new(pricing_rules)
  end

  def scan(code)
    increment_product_count(code)
  end

  def total
    products.sum(&method(:product_total)).to_f
  end

  private

  def increment_product_count(code)
    @products[code] = 0 unless @products.has_key?(code)
    @products[code] += 1
  end

  def product_total(args)
    code, count = args
    base_price = product_price(code)

    return base_price * count unless @discounts.applicable_to?(code)
    @discounts.price_for(code, base_price, count)
  end

  def product_price(code)
    Product.where(code: code).pluck(:price).first
  end
end
