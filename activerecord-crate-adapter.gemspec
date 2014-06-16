# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-crate-adapter/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-crate-adapter"
  spec.version       = ActiverecordCrateAdapter::VERSION
  spec.authors       = ["Christoph Klocker"]
  spec.email         = ["christoph@vedanova.com"]
  spec.summary       = "Active Record Crate Data Adapter"
  #spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "debugger"
  spec.add_development_dependency "rspec", "~> 2.14"

  spec.add_dependency('activerecord', '>= 4.0.0')
  spec.add_dependency('arel', '>= 4.0.0')
  spec.add_dependency('crate_ruby', '~> 0.0.5')

end
