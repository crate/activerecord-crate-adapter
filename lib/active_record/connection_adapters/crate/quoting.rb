module ActiveRecord
  module ConnectionAdapters
    module Crate
      module Quoting
        # Quotes the column value to help prevent
        # {SQL injection attacks}[http://en.wikipedia.org/wiki/SQL_injection].
        def quote(value, column = nil)
          # records are quoted as their primary key
          return value.quoted_id if value.respond_to?(:quoted_id)

          if value.is_a?(Array)
            "#{value}".gsub('"', "'")
          elsif column.sql_type == 'object'
            "{ #{value} }"
          else
            super(value, column)
          end
        end
      end
    end
  end
end
