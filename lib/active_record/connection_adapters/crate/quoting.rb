module ActiveRecord
  module ConnectionAdapters
    module Crate
      module Quoting
        # Quotes the column value to help prevent
        # {SQL injection attacks}[http://en.wikipedia.org/wiki/SQL_injection].
        def quote(value, column = nil)
          # records are quoted as their primary key
          return value.quoted_id if value.respond_to?(:quoted_id)

          case value
            when Array
              "#{value}".gsub('"', "'")
            else
              super(value, column)
          end
        end
      end
    end
  end
end
