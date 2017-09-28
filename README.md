## Cabify Checkout

This is the implementation of the Checkout coding challenge, from my interpretation of the problem it seems to me it
is more about domain modelling and ruby (as well as some rails) competency. In order to keep things simple and 
to showcase git workflow I opted for what might be a Pull Request of the entire feature instead of bogging the
implementation down with a full-blown rails app.

For this solution I'm using some of Rails dependencies but the code is not constrained to all of rails, in particular
I'm using `ActiveRecord` for models and `ActiveSupport` just for `#classify` and `#constantize`. I've also added
a custom Rakefile with some convenience tasks in order to create / drop the db as well as generate and run migrations.

Now, for the good stuff; the solution uses a Strategy Pattern through STI; it leverages ActiveRecord for the heavy lifting of subclassing 
the appropriate discount strategy that's applicable to each code in the `Checkout` instance. I prefer this approach since it allows further
extensions in the future by implementing a new strategy, e.g. `TieredBulkPricing`, which could apply a 5% discount over 3 units, 
a 10% discount over 10 units, and a 15% discount over 50 units.

The implemented strategies are the following:

* `BulkPricing`, which handles the 5% discount over 3 units
* `BundledUnitsPricing` which handles the 2 for 1 discount.

The implemented strategies are flexible as well in that they're not constrained to "2 for 1" or 5% over 3 units or to a particular code:

* `BulkPricing` has the options `min_units` & `percentage` which handle the threshold for when to apply the percentage discount. So it can be used without code modifications in the future for a different discount such as 10% off when buying 20 units of a product
* `BundledUnitsPricing` has the options `divisor` & `multiplier` which handles how much `divisor` units to bundle into 
`multiplier` units. As with the strategy above, it can be used without code modifications to handle a 3 for 2, or any other combination of pricing on a product. 

As mentioned above, the strategies aren't hardcoded to a particular product code; since they're ActiveRecord objects,
they have a `code` attribute which is used by the `Checkout` instance to know to which product code it should be applied to.

In terms of git workflow, I use git-flow extensively as well as Pull Requests to close features and merge back into develop.
The closed PRs can be seen [here](https://github.com/CamonZ/cabify_checkout_rb/pulls?q=is%3Apr+is%3Aclosed)


In order to run the code, you'll need a running instance of PostgreSQL and the following steps:

* Clone this repository
* Run `bundle install`
* Run `rake db:create`


For tests you can run `bundle exec rspec`. I've also added a convenience `app.rb` file which creates the data for the db and creates a `Checkout` instance that's used to print 
the results of adding and totalling some products. You can run this last file through `ruby app.rb`


The code is hopefully pretty self-documenting, if you have any questions don't hesitate to shoot me an email.
