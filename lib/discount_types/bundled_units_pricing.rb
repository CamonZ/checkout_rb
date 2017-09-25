module DiscountTypes
  class BundledUnitsPricing
    def process(count, base_price, attrs)
      base_price * total_units(count, attrs)
    end

    private

    def total_units(count, attrs)
      divisor = attrs[:bundle_divisor]
      multiplier = attrs[:bundle_multiplier]

      bundled_units(count, divisor, multiplier) + remainder_units(count, divisor)
    end

    def bundled_units(count, bundle_divisor, bundle_multiplier)
      ( count / bundle_divisor ) * bundle_multiplier
    end

    def remainder_units(count, bundle_divisor)
      count % bundle_divisor
    end
  end
end
