# Run tests

Run CrateDB on port 44200.
```shell
docker run --rm -it --publish=44200:4200 crate:5.1.1 \
  -Cdiscovery.type=single-node \
  -Ccluster.routing.allocation.disk.threshold_enabled=false
```

Install project and invoke test suite.
```shell
bundle install
bundle exec rspec --backtrace
```


# Release Process

Business as usual, but in case you forgot, here it is.

* update `VERSION` in `lib/activerecord-crate-adapter/version.rb`
* update `history.txt` to reflect the changes of this release
* Do the traditional trinity of:

```shell
gem update --system
gem build gem build activerecord-crate-adapter.gemspec
gem push activerecord-crate-adapter-<version>.gem
```
