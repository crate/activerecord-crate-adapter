module ActiveRecord
  module ConnectionAdapters
    module DatabaseStatements
      def exec_query(sql, name = 'SQL', binds = [])
        result = nil
        log(sql, name, binds) {
          result = do_exec_query(sql, name, binds)
        }
        fields = result.cols
        ActiveRecord::Result.new(fields, result.values)
      end

      def do_exec_query(sql, name, binds)
        params = []
        binds.each_with_index do |(column, value), index|
          ar_column = column.is_a?(ActiveRecord::ConnectionAdapters::Column)
          # only quote where clause values
          unless ar_column # && column.sql_type == 'timestamp'
          v = value
          quoted_value = ar_column ? quote(v, column) : quote(v, nil)
          params << quoted_value
          else
            params << value
          end

        end
        @connection.execute sql, params
      end

      # Returns the statement identifier for the client side cache
      # of statements
      def sql_key(sql)
        sql
      end

      # Executes an SQL statement, returning a ResultSet object on success
      # or raising a CrateError exception otherwise.
      def execute(sql, name = nil)
        log(sql, name) do
          @connection.execute(sql)
        end
      end

      protected
      def select(sql, name, binds)
        exec_query(sql, name, binds)
      end

    end
  end
end