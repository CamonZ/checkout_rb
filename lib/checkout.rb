require 'active_support'
require 'product'

class Checkout
  attr_reader :products

  def initialize(pricing_rules)
    @products = {}
    @rules = pricing_rules
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
    return product_price(code) * count unless codes_with_rules.include?(code)
    price_with_rules(code, count)
  end

  def product_price(code)
    Product.where(code: code).pluck(:price).first
  end

  def codes_with_rules
    @rules.map { |rule| rule[:code] }
  end

  def price_with_rules(code, count)
    base_price = product_price(code)
    discount_class(code).new.process(count, base_price, discount_attributes(code))
  end

  def discount_attributes(code)
    discount_rule(code)[:attributes]
  end

  def discount_type(code)
    discount_rule(code)[:rule]
  end

  def discount_rule(code)
    @rules.select { |rule| rule[:code] == code }.first
  end

  def discount_class(code)
    begin
      class_name = ActiveSupport::Inflector.classify(discount_type(code))
      ActiveSupport::Inflector.constantize("DiscountTypes::#{class_name}")
    rescue NameError
      raise Exception.new("Unregistered discount type #{class_name} for product: #{code}")
    end
  end
end
