# Release Process

Business as usual, but in case you forgot, here it is.

* update `VERSION` in `lib/activerecord-crate-adapter/version.rb`
* update `history.txt` to reflect the changes of this release
* Do the traditional trinity of:

```ruby
gem update --system
gem build gem build activerecord-crate-adapter.gemspec
gem push activerecord-crate-adapter-<version>.gem
```

