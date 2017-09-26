require_relative 'discount_strategy'

class BulkPricing < DiscountStrategy
  validates_presence_of :min_units, :percentage
  validates_numericality_of :min_units
  validates_numericality_of :percentage, greater_than: 0, less_than_or_equal_to: 1

  def price_for(base_price, units_count)
    return units_count * base_price unless units_count >= min_units
    units_count * discounted_price(base_price, percentage)
  end

  def min_units
    options['min_units']
  end

  def min_units=(value)
    options['min_units'] = value
  end

  def percentage
    options['percentage']
  end

  def percentage=(value)
    options['percentage'] = value
  end

  private

  def discounted_price(base_price, percentage)
    base_price * (1 - percentage)
  end
end
