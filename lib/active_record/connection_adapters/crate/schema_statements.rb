module ActiveRecord
  module ConnectionAdapters
    class CrateAdapter < AbstractAdapter
      module SchemaStatements
        def primary_key(table_name)
          res = @connection.execute("select constraint_name from information_schema.table_constraints
where table_name = '#{quote_table_name(table_name)}' and constraint_type = 'PRIMARY_KEY'")
          res[0].try(:first).try(:first)
        end
      end
    end
  end
end