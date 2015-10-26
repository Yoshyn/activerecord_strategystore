module StrategyStore
  module Strategy
    class Column

      # Should be updated in Rails 5
      # TODO : Must be cleaned (binary, deciman_without_scale, ...?)
      # TODO : Manage Array & Hash
      CAST_MAPPING = {
        big_integer:            ::ActiveRecord::Type::BigInteger,
        binary:                 ::ActiveRecord::Type::Binary,
        boolean:                ::ActiveRecord::Type::Boolean,
        decimal:                ::ActiveRecord::Type::Decimal,
        decimal_without_scale:  ::ActiveRecord::Type::DecimalWithoutScale,
        float:                  ::ActiveRecord::Type::Float,
        integer:                ::ActiveRecord::Type::Integer,
        string:                 ::ActiveRecord::Type::String,
        text:                   ::ActiveRecord::Type::Text,
        unsigned_integer:       ::ActiveRecord::Type::UnsignedInteger,
        value:                  ::ActiveRecord::Type::Value
      }

      attr_accessor :name
      attr_accessor :type
      attr_accessor :default
      attr_accessor :null

      # Instantiates a new column .
      #
      # +name+    is the strategy column's name.
      # +type+    is the type of the columns, such as +string+.
      # +options+ is various information about the column (limit, scale, precision, null, default)
      # +null+    determines if this column allows +NULL+ values.
      def initialize(name, type, options = {})
        @cast_type = CAST_MAPPING.fetch(type).new(options.slice(:limit, :scale, :precision))
        @name    = name
        @type    = type
        @default = options[:default]
        @null    = options[:default] || true
      end

      # Cast a value using ActiveRecord::Type .
      def cast(value)
        @cast_type.send(:cast_value, value)
      end
    end
  end
end
