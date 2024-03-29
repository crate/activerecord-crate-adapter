[![Gem version](https://badge.fury.io/rb/activerecord-crate-adapter.svg)](https://rubygems.org/gems/activerecord-crate-adapter)
[![Build status](https://github.com/crate/activerecord-crate-adapter/actions/workflows/tests.yml/badge.svg)](https://github.com/crate/activerecord-crate-adapter/actions/workflows/tests.yml)
[![Code Climate](https://codeclimate.com/github/crate/activerecord-crate-adapter.png)](https://codeclimate.com/github/crate/activerecord-crate-adapter)


## About

The Ruby on Rails ActiveRecord adapter for [CrateDB],
using the [crate_ruby] driver with HTTP connectivity.

**Note:** The `activerecord-crate-adapter` currently only works with Rails 4.1.x.


## Installation

Add this line to your application's `Gemfile`:

    gem 'activerecord-crate-adapter'

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

CrateDB doesn't come with an autoincrement feature for your model ids. So you need to set
it yourself. One way is to use `SecureRandom.uuid`, if you think there is a better one,
please add an issue, so we can discuss.

    class Post < ActiveRecord::Base

      before_validation :set_id, on: :create

      private

      def set_id
        self.id = SecureRandom.uuid
      end

    end

## Special data types

### Array
You can simply create Array columns by specifying `t.array` and passing `array_type` when you create a migration.

    t.array :tags, array_type: :string
    t.array :votes, array_type: :integer
    t.array :bool_arr, array_type: :boolean

When you create an object just pass your Array directly

    Post.create!(title: 'Arrays are awesome', tags: %w(hot fresh), votes: [1,2])
    post = Post.where("'fresh' = ANY (tags)")

### Object
CrateDB allows you to define nested objects. I tried to make it as simply as possible to use and reuse existing AR functionality,
I therefore ask you to reuse the existing serialize functionality. `AR#serialize` allows you to define your own serialization
mechanism, and we simply reuse that for serializing an AR object. To get serialize working simply create `#dump` and `#load` methods
on the class that creates a literal statement that is then used in the SQL. Read up more in this [commit about array and object literals].

I tried to make your guys life easier and created a module that does this automatically for you. Simply make all attributes accessible
and assign it in the initializer. So a serialized class should look like this:

    require 'active_record/attribute_methods/crate_object'

    class Address
      attr_accessor :street, :city, :phones, :zip

      include CrateObject

      def initialize(opts)
        @street = opts[:street]
        @city = opts[:city]
        @phones = opts[:phones]
        @zip = opts[:zip]
      end

    end

Check out the `CrateObject` module if you need to write your own serializer.

Then in your model simply use `#serialize` to have objects working.

      class User < ActiveRecord::Base
        serialize :address, Address
      end

Note: I do not plan to support nested objects inside objects.

#### Object Migrations

In the migrations, you can create an object, specify the object behaviour 
`(strict|dynamic|ignored)`, and its schema.

    t.object :address, object_schema_behaviour: :strict,
                       object_schema: {street: :string, city: :string, phones: {array: :string}, zip: :integer}



## Migrations

Currently, adding and dropping indices is not support by CrateDB, see [issue #733].

    # not supported by CrateDB yet
    add_index :posts, :comment_count
    remove_index :posts, :comment_count


## Caveats

CrateDB is eventually consistent, that means if you create a record, and query
for it right away, it won't work (except queries for the primary key).

In this context, read more about the [`REFRESH TABLE`] statement.

## Tests

See [DEVELOP.md](DEVELOP.md).


## Contributing

If you think something is missing, either create a pull request
or log a new issue, so someone else can tackle it.
Please refer to [CONTRIBUTING.rst](CONTRIBUTING.rst) for further information.

## Maintainers

* [Crate.IO GmbH](https://crate.io)
* [Christoph Klocker](http://vedanova.com), [@corck](https://twitter.com/corck)

## License

This project is licensed under the [Apache License 2.0].


[Apache License 2.0]: https://github.com/crate/activerecord-crate-adapter/blob/master/LICENSE
[commit about array and object literals]: https://github.com/crate/crate/commit/16a3d4b3f2
[CrateDB]: https://github.com/crate/crate
[crate_ruby]: https://github.com/crate/crate_ruby
[issue #733]: https://github.com/crate/crate/issues/733
[`REFRESH TABLE`]: https://crate.io/docs/crate/reference/en/latest/general/dql/refresh.html
