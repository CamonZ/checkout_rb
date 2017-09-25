require 'active_support'

class DiscountProcessor
  def initialize(pricing_rules)
    @rules = pricing_rules.each_with_object({}, &method(:rules_mapper))
  end

  def applicable_to?(code)
    applicable_codes.include?(code)
  end

  def price_for(code, base_price, count)
    discount_strategy(code).total(base_price, count)
  end

  private

  def rules_mapper(rule, acc)
    code = rule[:code]
    acc[code] = rule
  end

  def applicable_codes
    @rules.keys
  end

  def discount_attributes(code)
    discount_rule(code)[:attributes]
  end

  def discount_type(code)
    discount_rule(code)[:rule]
  end

  def discount_rule(code)
    @rules[code]
  end

  def discount_strategy(code)
    options = discount_attributes(code)
    discount_class(code).new(options)
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
