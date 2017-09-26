require 'bundler'
require 'yaml'

Bundler.require(:default)

Dir['./lib/**/*.rb'].each { |f| require f }

config = YAML::load(File.open('config/database.yml'))['default']
ActiveRecord::Base.establish_connection(config)


# Create products
Product.create(name: 'Cabify Awesome T-Shirt', code: 'TSHIRT', price: 20.0)
Product.create(name: 'Cabify Awesome Mug', code: 'MUG', price: 7.5)
Product.create(name: 'Cabify Awesome Voucher', code: 'VOUCHER', price: 5.0)

# Create pricing rules

tshirts_bulk_pricing = BulkPricing.find_or_create_by(code: 'TSHIRT', options: { min_units: 3, percentage: 0.05 })
vouchers_2_for_1 = BundledUnitsPricing.find_or_create_by(code: 'VOUCHER', options: { divisor: 2, multiplier: 1 })

checkout = Checkout.new([tshirts_bulk_pricing, vouchers_2_for_1])


checkout.scan("TSHIRT")
checkout.scan("TSHIRT")
puts "The price of 2 tshirts is: #{checkout.total}"

checkout.scan("TSHIRT")
puts "The price of 3 tshirts is: #{checkout.total}"

checkout.clear

checkout.scan("VOUCHER")
puts "The price of 1 voucher is: #{checkout.total}"

checkout.scan("VOUCHER")
puts "The price of 2 vouchers is: #{checkout.total}"

checkout.scan("VOUCHER")
puts "The price of 3 vouchers is: #{checkout.total}"

puts "Now, lets add 4 tshirts and a couple of mugs to our existing checkout process"

4.times { checkout.scan("TSHIRT") }
2.times { checkout.scan("MUG") }

puts "The new total is: #{checkout.total}"
