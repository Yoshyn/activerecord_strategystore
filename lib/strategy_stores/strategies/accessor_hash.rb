module StrategyStore
  module Strategies
    class AccessorHash

      attr_accessor :source
      attr_accessor :columns

      # TODO - rpc : Set the columns when registering the strategy with const :
      # class << self
      #   attr_reader :columns
      #   def create(columns)
      #     Class.new(self) do @columns = columns; end
      #   end
      # end
      # def columns; self.class.columns; end
      #
      # def initialize(source)
      #   @source  = source
      #   @source.slice!(*default_attributes.keys)
      #   @source.reverse_merge!(default_attributes)
      # end

      def initialize(source, columns)
        @source  = source
        @columns = columns
        @source.slice!(*default_attributes.keys)
        @source.reverse_merge!(default_attributes)
      end

      def []=(key, value); source[key] = cast(key, value); end
      def [](key);         cast(key, source[key]);           end

      def method_missing(method_name, *args, &block)
        if source.respond_to?(method_name, false) # FIXME : include_private method?
          source.send(method_name, *args, &block)
        else
          super
        end
      end

      private
      def cast(key, value)
        columns[key].cast(value)
      end

      def default_attributes
        columns.values.inject({}) do |acc, column|
          acc[column.name] = column.default
          acc
        end
      end
    end
  end
end
