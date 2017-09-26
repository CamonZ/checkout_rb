require 'active_record'

class Product < ActiveRecord::Base
  validates_presence_of :name, :code, :price
  validates_numericality_of :price
  validates_uniqueness_of :code
end
