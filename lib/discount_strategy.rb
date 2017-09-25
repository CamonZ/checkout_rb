require 'active_record'

class DiscountStrategy < ActiveRecord::Base
  validates_presence_of :code
  validates_uniqueness_of :code

  serialize :options, JSON
end
