require_relative 'discount_strategy'

class BundledUnitsPricing < DiscountStrategy
  validates_presence_of :divisor, :multiplier
  validates_numericality_of :divisor, :multiplier

  def price_for(base_price, units_count)
    base_price * total_units(units_count)
  end

  # serialized hash has strings as keys
  def divisor
    options['divisor']
  end

  def multiplier
    options['multiplier']
  end

  def divisor=(value)
    options['divisor'] = value
  end

  def multiplier=(value)
    options['multiplier'] = value
  end

  private

  def total_units(units_count)
    bundled_units(units_count) + remainder_units(units_count)
  end

  def bundled_units(units_count)
    ( units_count / divisor ) * multiplier
  end

  def remainder_units(units_count)
    units_count % divisor
  end
end
