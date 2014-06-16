$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'activerecord-crate-adapter'
require 'logger'
#require 'debugger'

require 'dummy/app/models/post'

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