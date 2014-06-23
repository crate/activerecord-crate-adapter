[![Gem Version](https://badge.fury.io/rb/activerecord-crate-adapter.svg)](http://badge.fury.io/rb/activerecord-crate-adapter)

The [Crate](http://www.crate.io) adapter for ActiveRecord.



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
    
## Special Data Types

### Array
You can simply create Array columns by specifying t.array and passing array_type when you create a migration. You need at least the upcoming
release 0.39 of Crate for this functionality.
 
    t.array :tags, array_type: :string
    t.array :votes, array_type: :integer
    t.array :bool_arr, array_type: :boolean
    
When you create an object just pass your Array directly

    Post.create!(title: 'Arrays are awesome', tags: %w(hot fresh), votes: [1,2])
    post = Post.where("'fresh' = ANY (tags)")    

### Object
Crate allows you to define nested objects. You need at least the upcoming
release 0.39 of Crate for this functionality. I tried to make it as simply as possible to use and reuse existing AR functionality,
I therefore ask you to reuse the existing serialize functionality. AR#serialize allows you to define your own serialization
mechanism and we simply reuse that for serializing an AR object. To get serialize working simply create a #dump and #load method 
on the class that creates a literal statement that is then used in the SQL. Read up more in this [commit}(https://github.com/crate/crate/commit/16a3d4b3f23996a327f91cdacef573f7ba946017).

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

Check out CrateObject module if you need to write your own serializer. 
 
Then in your model simply use #serialize to have objects working

      class User < ActiveRecord::Base        
        serialize :address, Address  
      end

Note: I do not plan to support nested objects inside objects.

#### Object Migrations

In the migrations you can create an object and specify the object behaviour(strict|dynamic|ignored) and it's schema.
    
    t.object :address, object_schema_behaviour: :strict,
                       object_schema: {street: :string, city: :string, phones: {array: :string}, zip: :integer}
      
   

## Migrations

Currently adding and dropping indices is not support by Crate. Issue [#733](https://github.com/crate/crate/issues/733)

    # not supported by Crate yet
    add_index :posts, :comment_count
    remove_index :posts, :comment_count


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
