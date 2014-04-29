module ActiveRecord
  module ConnectionAdapters
   class CrateAdapter < AbstractAdapter
     class SchemaCreation < AbstractAdapter::SchemaCreation

       def add_column_options!(sql, options)
         if options[:array] || options[:column].try(:array)
           sql << '[]'
         end

         column = options.fetch(:column) { return super }
         if column.type == :uuid && options[:default] =~ /\(\)/
           sql << " DEFAULT #{options[:default]}"
         else
           super
         end
       end

     end

     module SchemaStatements
        def primary_key(table_name)
          res = @connection.execute("select constraint_name from information_schema.table_constraints
where table_name = '#{quote_table_name(table_name)}' and constraint_type = 'PRIMARY_KEY'")
          res[0].try(:first).try(:first)
        end

        # overriding as Crate does not support "version primary key" syntax. Need to add the column type.
        def initialize_schema_migrations_table
          unless table_exists?('schema_migrations')
            execute("CREATE TABLE schema_migrations (version string primary key INDEX using plain)")
          end
        end

        def add_index(table_name, column_name, options = {}) #:nodoc:
          puts
          puts "#########"
          puts "Adding indices is currently not supported by Crate"
          puts "See issue: https://github.com/crate/crate/issues/733"
          puts "#########"
          puts
          end

        def remove_index(table_name, column_name, options = {}) #:nodoc:
          puts
          puts "#########"
          puts "Dropping indices is currently not supported by Crate"
          puts "See issue: https://github.com/crate/crate/issues/733"
          puts "#########"
          puts
        end

      end
    end
  end
end