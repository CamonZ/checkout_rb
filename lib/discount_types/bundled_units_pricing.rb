module DiscountTypes
  class BundledUnitsPricing
    attr_reader :divisor, :multiplier

    def initialize(attrs)
      @divisor = attrs[:bundle_divisor]
      @multiplier = attrs[:bundle_multiplier]
    end

    def total(base_price, count)
      base_price * total_units(count)
    end

    private

    def total_units(count)
      bundled_units(count) + remainder_units(count)
    end

    def bundled_units(count)
      ( count / divisor ) * multiplier
    end

    def remainder_units(count)
      count % divisor
    end
  end
end
