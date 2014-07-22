# -*- coding: utf-8; -*-
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

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'activerecord-crate-adapter'
require 'logger'
#require 'debugger'

require 'dummy/app/models/address'
require 'dummy/app/models/post'
require 'dummy/app/models/user'

RSpec.configure do |config|

  config.before(:each) do
  end
  config.after(:each) do
  end
  config.before(:suite) do
    connect
  end
  config.after(:all) do
  end
end

def connect
  ActiveRecord::Base.logger = Logger.new("log/debug.log")
  ActiveRecord::Base.logger.level = Logger::DEBUG
  ActiveRecord::Base.configurations = {
      'arunit' => {
          adapter: 'crate',
          min_messages: 'warning',
          port: 4209,
          host: '127.0.0.1'
      }
  }
  ActiveRecord::Base.establish_connection :arunit
end

# Crate is eventually consistent therefore we need
# to refresh the table when doing queries, except we
# query for the primary key
def refresh_posts
  Post.connection.raw_connection.refresh_table('posts')
end