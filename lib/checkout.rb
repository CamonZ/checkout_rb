require 'active_support'
require_relative 'product'

class Checkout
  attr_reader :products

  def initialize(pricing_rules)
    @products = {}
    @rules = pricing_rules.each_with_object({}, &method(:rules_mapper))
  end

  def scan(code)
    increment_product_count(code)
  end

  def total
    products.sum(&method(:product_total)).to_f
  end

  private

  def rules_mapper(rule, acc)
    code = rule[:code]
    acc[code] = rule
  end

  def increment_product_count(code)
    @products[code] = 0 unless @products.has_key?(code)
    @products[code] += 1
  end

  def product_total(args)
    code, count = args
    base_price = product_price(code)

    return base_price * count unless discount_applicable_to?(code)
    discount_strategy(code).price_for(base_price, count)
  end

  def product_price(code)
    Product.where(code: code).pluck(:price).first
  end

  def discount_strategy(code)
    @rules[code]
  end

  def discount_applicable_to?(code)
    @rules.keys.include?(code)
  end
end
