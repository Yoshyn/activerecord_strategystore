module StrategyStore
  module Strategies
    class DSL
      attr_reader :columns

      def initialize
        @columns = []
        yield self
      end

      def column(name, type, options = {})
        @columns << Column.new(name, type, options)
      end

      [:string, :text, :integer, :float, :datetime, :date, :boolean, :any].each do |type|
        define_method(type) do |name, options = {}|
          column(name, type, options)
        end
      end
    end
  end
end
