# DecisionMaker [![Build Status](https://travis-ci.org/sunaot/decision_maker.svg?branch=master)](https://travis-ci.org/sunaot/decision_maker)

DecisionMaker is a library which help you to gerate simple decision table and make complicated dispatching logic much simpler. See Usage for details.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decision_maker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install decision_maker

## Usage

Simple dynamic definition style.

```ruby
require 'decision_maker'

ticket_price = DecisionMaker.generate do
  rule(
    child:   { condition:  0..9,   action: 600 },
    student: { condition: 10..16,  action: 1200 },
    adult:   { condition: ->(age) { age > 16 }, action: 2000 },
  )
end

ticket_price.call(20) #=> 2000
```

Class definition style.

```ruby
require 'decision_maker'

TicketPrice = DecisionMaker.define do
  rule(
    child:   { condition:  0..9,   action: 600 },
    student: { condition: 10..16,  action: 1200 },
    adult:   { condition: ->(age) { age > 16 }, action: 2000 },
  )
end

ticket_price = TicketPrice.new
ticket_price.call(20) #=> 2000
```

Dynamic definition style with some name customizations.

```ruby
require 'decision_maker'

ticket_price = DecisionMaker.generate do
  name           :calculate
  condition_name :age
  action_name    :price

  rule(
    child:   { age:  0..9,   price: 600 },
    student: { age: 10..16,  price: 1200 },
    adult:   { age: ->(age) { age > 16 }, price: 2000 },
  )
end

ticket_price.calculate(20) #=> 2000
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sunaot/decision_maker.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

