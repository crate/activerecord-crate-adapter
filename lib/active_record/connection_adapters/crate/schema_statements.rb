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

module ActiveRecord
  module ConnectionAdapters
    module Crate
      class SchemaCreation < ActiveRecord::ConnectionAdapters::SchemaCreation
        private

        def add_column_options!(sql, options)
          if options[:array] || options[:column].try(:array)
            sql.gsub!(/(.*)\s(\w+)$/, '\1 array(\2)')
          end
          super(sql, options)
        end

      end

      module SchemaStatements
        def data_source_sql(name = nil, type: nil)
          # TODO implement
          nil
        end

        def quoted_scope(name = nil, type: nil)
          # TODO implement
          nil
        end

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