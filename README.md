Qwrapper
========

[![Gem Version](https://badge.fury.io/rb/qwrapper.svg)](http://badge.fury.io/rb/qwrapper) [![Build Status](https://travis-ci.org/NeMO84/qwrapper.svg?branch=master)](https://travis-ci.org/NeMO84/qwrapper) [![Dependency Status](https://gemnasium.com/NeMO84/qwrapper.svg)](https://gemnasium.com/NeMO84/qwrapper) [![Code Climate](https://codeclimate.com/github/NeMO84/qwrapper/badges/gpa.svg)](https://codeclimate.com/github/NeMO84/qwrapper) [![Test Coverage](https://codeclimate.com/github/NeMO84/qwrapper/badges/coverage.svg)](https://codeclimate.com/github/NeMO84/qwrapper)

QWrapper is an attempt to make queue systems like SQS, AMQP, Redis consisten when advanced features aren't necessary. When simple dequeue, enqueue, poll, subscribe actions are the primary interfaces used then abstracting the logic can really DRY up code and simplyify usage.

## NOTE

This GEM is still in development phase. Please don't use this yet. I am still figuring out best use cases and proper conventions. Feel free to provide insight via issues.

## Installation

Add this line to your application's Gemfile:

    gem 'qwrapper'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install qwrapper

## Usage

### Publish

```ruby
require "qwrapper"

Qwrapper.config = {
  queue_type: :rabbitmq,
  host: "localhost",
  keepalive: true
}
Qwrapper.queue.publish("qwrapper", "test")

# OR

config = {
  host: "localhost",
  keepalive: true
}
queue = Qwrapper::Queues::RabbitMQ.new(config)
queue.publish("qwrapper", "test2")
```


### Subscribe

```ruby
require "qwrapper"

# Define custom classes for which to automatically
# requeue messages for.
class RetryError < StandardError; end

Qwrapper.config = {
  queue_type: :rabbitmq,
  host: "localhost",
  keepalive: true
}
Qwrapper.queue.subscribe("qwrapper") do |message, logger|
  # raise RetryError.new "Something temporary"
  logger.debug "Doing some work...#{message}"
  raise RetryError, "Some unexpected error occurred" if [true, false].sample
end

# OR

config = {
  host: "localhost",
  requeue_exceptions: [RetryError]
}
queue = Qwrapper::Queues::RabbitMQ.new(config)
queue.subscribe("qwrapper") do |message, logger|
  # raise RetryError.new "Something temporary"
  logger.debug "Doing some work...#{message}"
  raise RetryError, "Some unexpected error occurred" if [true, false].sample
end
```

## TODO

  - Add requeue logic
  - Add poison queue logic
  - Improve logging. Make more intuitive w/o abusing it
  - Think up more TODO items; there are plenty of concerns not listed here


## Known Issues

TODO:


## Contributing

1. Fork it ( https://github.com/[my-github-username]/qwrapper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


