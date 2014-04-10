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

      # Converts an arel AST to SQL
      def to_sql(arel, binds = [])
        if arel.respond_to?(:ast)
          binds = binds.dup
          visitor.accept(arel.ast) do
            quote(*binds.shift.reverse)
          end
        else
          arel
        end
      end

      def do_exec_query(sql, name, binds)
        params = []
        binds.each_with_index do |(column, value), index|
          ar_column = column.is_a?(ActiveRecord::ConnectionAdapters::Column)
          next if ar_column && column.sql_type == 'timestamp'
          v = value
          quoted_value = ar_column ? quote(v, column) : quote(v, nil)
          params << quoted_value
        end
        params.each { |p| sql.sub!(/(\?)/, p) }
        @connection.execute sql
      end

      # Returns the statement identifier for the client side cache
      # of statements
      def sql_key(sql)
        sql
      end

      protected
      def select(sql, name, binds)
        exec_query(sql, name, binds)
      end

    end
  end
end