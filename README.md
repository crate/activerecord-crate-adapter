# Activerecord::Crate::Adapter

The [Crate](http://www.crate.io) adapter for ActiveRecord.

## Work in progress

I've just started coding the adapter and lots of functionality might still not work. Give it a try
and help bei either contributing (fix it) or add a ne issue.


## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-crate-adapter', :git => "https://github.com/crate/activerecord-crate-adapter.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-crate-adapter

## Usage

When using Rails update your database.yml

     development:
       adapter: crate
       host: 127.0.0.1
       port: 4200

Crate doesn't come with an autoincrement feature for your model ids. So you need to set
it yourself. One way is to use SecureRandom.uuid, if you think there is a better one,
please add an issue so we can discuss.

    class Post < ActiveRecord::Base

      before_validation :set_id

      private

      def set_id
        self.id = SecureRandom.uuid
      end

    end

## Migrations

Currently adding and dropping indices is not support by Crate. Issue [#733](https://github.com/crate/crate/issues/733)

    # not supported by Crate yet
    add_index :posts, :comment_count
    remove_index :posts, :comment_count

## Missing functionality

Array and Object column types are currently not supported in migrations.

## Gotchas

Crate is eventually consistent, that means if you create a record and query for it right away it
won't work (except queries for the primary key!). Read more about it [here](https://github.com/crate/crate/blob/master/docs/sql/dml.txt#L569)

Crate does not support Joins (yet) so joins won't work.

## Tests

First run the test instance of crate

    $ ./spec/test_server.rb

then run the tests

    $ rspec spec

## Contributing

This adapter is a work in progress. If you think something is missing, either follow the steps below
or log a new issue, so someone else can tackle it.

1. Fork it ( `http://github.com/crate/activerecord-crate-adapter/fork` )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Add tests
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

##Maintainer

* [Christoph Klocker](http://www.vedanova.com), [@corck](http://www.twitter.com/corck)

##License
MIT License. Copyright 2014 Christoph Klocker. [http://vedanova.com](http://vedanova.com)
