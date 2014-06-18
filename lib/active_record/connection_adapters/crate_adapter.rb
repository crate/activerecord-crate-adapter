require 'active_record'
require 'active_record/base'
require 'active_record/base'
require 'arel/arel_crate'
require 'arel/visitors/bind_visitor'
require 'active_support/dependencies/autoload'
require 'active_support/callbacks'
require 'active_support/core_ext/string'
require 'active_record/connection_adapters/abstract_adapter'
require 'active_record/connection_adapters/statement_pool'
require 'active_record/connection_adapters/column'
require 'active_record/connection_adapters/crate/schema_statements'
require 'active_record/connection_adapters/crate/database_statements'
require 'active_record/connection_adapters/crate/quoting'
require 'active_support/core_ext/kernel'

begin
  require 'crate_ruby'
rescue LoadError => e
  raise e
end

module ActiveRecord

  class Base
    def self.crate_connection(config) #:nodoc:
      config = config.symbolize_keys
      ConnectionAdapters::CrateAdapter.new(nil, logger, nil, config)
    end
  end

  module ConnectionAdapters
    class CrateAdapter < AbstractAdapter
      class ColumnDefinition < ActiveRecord::ConnectionAdapters::ColumnDefinition
        attr_accessor :array, :object
      end

      include Crate::SchemaStatements
      include DatabaseStatements
      include Crate::Quoting

      ADAPTER_NAME = 'Crate'.freeze

      def schema_creation # :nodoc:
        Crate::SchemaCreation.new self
      end

      NATIVE_DATABASE_TYPES = {
          boolean:     { name: "boolean" },
          string:      { name: "string"},
          integer:     { name: "integer" },
          float:       { name: "float" },
          binary:      { name: "byte" },
          datetime:    { name: "timestamp" },
          timestamp:   { name: "timestamp" },
          object:      { name: "object" },
          array:       { name: "array"}
      }

      class BindSubstitution < Arel::Visitors::Crate # :nodoc:
        include Arel::Visitors::BindVisitor
      end

      def initialize(connection, logger, pool, config)
        @port = config[:port]
        @host = config[:host]
        super(connection, logger, pool)
        @schema_cache = SchemaCache.new self
        @visitor = Arel::Visitors::Crate.new self
        @quoted_column_names = {}
        connect
      end

      def adapter_name
        ADAPTER_NAME
      end

      # Adds `:array` option to the default set provided by the
      # AbstractAdapter
      def prepare_column_options(column, types)
        spec = super
        spec[:array] = 'true' if column.respond_to?(:array) && column.array
        spec
      end

      # Adds `:array` as a valid migration key
      def migration_keys
        super + [:array]
      end


      #TODO check what call to use for active
      def active?
        true
      end

      #TODO
      def clear_cache!
      end

      #TODO
      def reset!
      end

      def supports_migrations?
        true
      end

      def connect
        @connection = CrateRuby::Client.new(["#{@host}:#{@port}"])
      end

      def columns(table_name) #:nodoc:
        cols = @connection.table_structure(table_name).map do |field|
          CrateColumn.new(field[2], nil, field[4], nil)
        end
        cols
      end

      def tables
        @connection.tables
      end

      # def quote_column_name(name) #:nodoc:
      #   @quoted_column_names[name] ||= %Q{"#{name.to_s}"}
      # end

      class CrateColumn < Column
      end

      class TableDefinition < ActiveRecord::ConnectionAdapters::TableDefinition

        # Crate doesn't support auto incrementing, therefore we need to manually
        # set a primary key. You need to assure that you always provide an unique
        # id. This might be done via the
        # +SecureRandom.uuid+ method and a +before_save+ callback, for instance.
        def primary_key(name, type = :primary_key, options = {})
          options[:primary_key] = true
          column name, "STRING PRIMARY KEY", options
        end

        def column(name, type = nil, options = {})
          super
          column = self[name]
          column.array = options[:array]
          column.object = options[:object]
          self
        end

        def object(name, type = nil, options = {})
          column name, "object", options.merge(object: true)
        end

        private

        def create_column_definition(name, type)
          ColumnDefinition.new name, type
        end


      end

      def create_table_definition(name, temporary, options, as = nil)
        TableDefinition.new native_database_types, name, temporary, options, as
      end

      def native_database_types
        NATIVE_DATABASE_TYPES
      end
    end
  end


end
