require 'bigdecimal'
module DiscountTypes
  class BulkPricing
    def process(count, base_price, attrs)
      min_units = attrs[:min_units]
      percentage = attrs[:percentage]

      return count * base_price unless count >= min_units
      count * base_price * (1 - percentage)
    end
  end
end
