# coding: utf-8
#
# Licensed to CRATE Technology GmbH ("Crate") under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  Crate licenses
# this file to you under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.  You may
# obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.
#
# However, if you have executed another commercial license agreement
# with Crate these terms will supersede the license and you may use the
# software solely pursuant to the terms of the relevant commercial agreement.

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-crate-adapter/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-crate-adapter"
  spec.version       = ActiverecordCrateAdapter::VERSION
  spec.authors       = ["Christoph Klocker", "Crate.IO GmbH"]
  spec.email         = ["office@crate.io"]
  spec.summary       = "ActiveRecord adapter for CrateDB"
  spec.description   = "ActiveRecord adapter for CrateDB, the distributed SQL database based on Lucene"
  spec.homepage      = "https://crate.io"
  spec.license       = "Apache License, v2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/crate/activerecord-crate-adapter/issues",
    "changelog_uri"   => "https://github.com/crate/activerecord-crate-adapter/blob/main/history.txt",
    "source_code_uri" => "https://github.com/crate/activerecord-crate-adapter"
  }

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.13"

  spec.add_dependency('activerecord', '~> 4.1.0')
  spec.add_dependency('arel', '>= 5.0.0')
  spec.add_dependency('crate_ruby', '~> 0.2.0')
  # https://github.com/ruby/bigdecimal#which-version-should-you-select
  spec.add_dependency('bigdecimal', '~> 1.4')
end
