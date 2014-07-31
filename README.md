## Installation

Add this line to your application's Gemfile:

    gem 'sequel_transaction'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_transaction

## Sidekiq Wireup

To automatically wrap Sidekiq work processes in a transaction, add the following:

```ruby
Sidekiq.configure_server do |c|
  c.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::Transaction,
      connection: Sequel.connect('sqlite:///')
  end
end
```

## Rack Wireup

To automatically wrap requests in a transaction, add the following:

```ruby
use Rack::Transaction,
  connection: Sequel.connect('sqlite:///')
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
