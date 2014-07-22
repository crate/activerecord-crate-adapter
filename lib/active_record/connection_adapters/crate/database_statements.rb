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