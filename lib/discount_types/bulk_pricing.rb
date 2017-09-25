require 'bigdecimal'
module DiscountTypes
  class BulkPricing
    attr_reader :min_units, :percentage

    def initialize(attrs)
      @min_units = attrs[:min_units]
      @percentage = attrs[:percentage]
    end

    def total(base_price, units_count)
      return units_count * base_price unless units_count >= min_units
      units_count * discounted_price(base_price, percentage)
    end

    private

    def discounted_price(base_price, percentage)
      base_price * (1 - percentage)
    end
  end
end
